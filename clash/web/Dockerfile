# 使用官方 Python 3.11 镜像作为基础
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 安装依赖（提前复制 requirements.txt）
COPY requirements.txt .

# 安装依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制你的应用代码
COPY main.py .

# 设置容器对外暴露的端口
EXPOSE 8000

# 启动命令
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
