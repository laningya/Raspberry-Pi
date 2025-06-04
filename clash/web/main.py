from fastapi import FastAPI, Query, HTTPException, BackgroundTasks
from fastapi.responses import FileResponse
from fastapi.middleware.gzip import GZipMiddleware
import httpx
import tempfile
import yaml
from pathlib import Path
import os

app = FastAPI(title="Clash配置生成器")

# 启用GZip压缩中间件
app.add_middleware(GZipMiddleware, minimum_size=1024)

@app.get("/api/v1/clash-config",
         summary="生成Clash配置",
         description="动态替换订阅URL并保留原始规则配置")
async def generate_clash_config(
    background_tasks: BackgroundTasks,
    subscription_url: str = Query(..., 
        min_length=8,
        example="https://your.subscription.com/config.yaml",
        description="需要注入的订阅地址（必须包含http/https协议）"),
    filename: str = Query("clash-config.yml",
        regex=r"^[\w\-\.]+\.yml$",
        description="下载配置的文件名（必须以.yml结尾）")
) -> FileResponse:
    """
    核心功能：
    1. 从GitHub获取原始配置模板
    2. 替换proxy-providers.provider1.url字段
    3. 保留所有其他配置（包括magpie/micu规则）
    4. 生成临时文件并自动清理
    """
    try:
        # 输入验证
        if not subscription_url.lower().startswith(("http://", "https://")):
            raise HTTPException(400, "订阅地址必须包含http/https协议头")

        # 获取原始配置模板
        template_url = "https://raw.githubusercontent.com/laningya/Raspberry-Pi/master/clash/config.yml"
        async with httpx.AsyncClient(timeout=15) as client:
            response = await client.get(template_url)
            response.raise_for_status()
            config_data = yaml.safe_load(response.text)

        # 修改provider配置
        try:
            providers = config_data["proxy-providers"]
            if "provider1" not in providers:
                raise KeyError("provider1")
            providers["provider1"]["url"] = subscription_url
        except KeyError as e:
            raise HTTPException(500, f"模板缺少必要字段: {str(e)}")

        # 创建安全临时文件
        fd, temp_path = tempfile.mkstemp(suffix="_clash.yml")
        os.close(fd)  # 关闭文件描述符，后续通过Path操作
        temp_file = Path(temp_path)
        
        # 写入修改后的配置
        try:
            with open(temp_file, "w", encoding="utf-8") as f:
                yaml.dump(config_data, f, 
                          allow_unicode=True,
                          sort_keys=False,  # 保持原有字段顺序
                          default_flow_style=False)  # 禁用内联格式
        except IOError as e:
            raise HTTPException(500, f"文件写入失败: {str(e)}")

        # 添加自动清理任务
        background_tasks.add_task(lambda: temp_file.unlink())

        # 返回文件响应
        return FileResponse(
            temp_file,
            filename=filename,
            media_type="application/yaml",
            headers={
                "X-Config-Source": template_url,
                "Cache-Control": "no-cache, no-store"
            }
        )

    except httpx.HTTPStatusError as e:
        error_msg = f"获取模板失败: HTTP {e.response.status_code}"
        raise HTTPException(502, error_msg)
    except httpx.RequestError as e:
        raise HTTPException(504, f"连接模板服务器超时: {str(e)}")
    except yaml.YAMLError as e:
        raise HTTPException(500, f"YAML解析错误: {str(e)}")
    except HTTPException:
        raise  # 直接传递已生成的HTTP异常
    except Exception as e:
        raise HTTPException(500, f"未知错误: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
