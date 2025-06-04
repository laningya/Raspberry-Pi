from fastapi import FastAPI, Query
from fastapi.responses import PlainTextResponse
import httpx
import yaml

app = FastAPI()

RAW_YAML_URL = "https://raw.githubusercontent.com/laningya/Raspberry-Pi/refs/heads/master/clash/config.yml"

@app.get("/api/v1/proxy", response_class=PlainTextResponse)
async def proxy(url: str = Query(..., description="订阅地址")):
    # 获取远程 YAML 文件内容
    async with httpx.AsyncClient() as client:
        response = await client.get(RAW_YAML_URL)
        response.raise_for_status()
        original_yaml_text = response.text

    # 解析 YAML 为字典
    try:
        yaml_data = yaml.safe_load(original_yaml_text)
    except yaml.YAMLError as e:
        return PlainTextResponse(f"YAML 解析错误: {str(e)}", status_code=500)

    # 替换指定字段的值
    try:
        yaml_data["proxy-providers"]["provider1"]["url"] = str(url)
    except KeyError as e:
        return PlainTextResponse(f"指定字段不存在: {str(e)}", status_code=500)

    # 转换回 YAML 字符串，url 值自动用引号包裹
    modified_yaml = yaml.dump(yaml_data, allow_unicode=True, default_flow_style=False, sort_keys=False)

    return modified_yaml
