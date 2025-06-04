from fastapi import FastAPI, Query
from fastapi.responses import FileResponse
import httpx
import tempfile
import yaml
import os

app = FastAPI()

@app.get("/api/v1/proxy")
async def proxy(
    url: str = Query(..., description="URL to insert"),
    filename: str = Query("config.yml", description="Returned filename, e.g., config.yml")
):
    # GitHub raw 文件地址
    raw_url = "https://raw.githubusercontent.com/laningya/Raspberry-Pi/refs/heads/master/clash/config.yml"

    # 下载原始 YAML 文件
    async with httpx.AsyncClient() as client:
        response = await client.get(raw_url)
        response.raise_for_status()
        original_yaml = response.text

    # 解析 YAML 并修改 provider1.url
    try:
        config = yaml.safe_load(original_yaml)
        if "proxy-providers" in config and "provider1" in config["proxy-providers"]:
            config["proxy-providers"]["provider1"]["url"] = f'"{url}"'  # 加引号
    except Exception as e:
        return {"error": f"Failed to parse/modify YAML: {str(e)}"}

    # 写入临时 YAML 文件
    with tempfile.NamedTemporaryFile(mode="w+", delete=False, suffix=".yml") as tmp:
        yaml.dump(config, tmp, allow_unicode=True)
        tmp_path = tmp.name

    # 返回文件并设置下载文件名
    return FileResponse(
        tmp_path,
        media_type="application/x-yaml",
        filename="config.yaml"
    )
