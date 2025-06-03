# Dockerfile for lx-music-api-server
# 使用官方Python 3.8镜像作为基础
FROM python:3.8-slim

# 设置项目目录和数据目录
RUN mkdir -p /usr/src/app /app
WORKDIR /usr/src/app

# 复制项目文件到容器
COPY . .

# 安装项目依赖（使用清华PyPI镜像加速）
RUN pip install --no-cache-dir -r requirements.txt

# 设置工作目录为数据目录
WORKDIR /app

# 暴露服务端口
EXPOSE 9763

# 设置容器启动命令（从项目目录运行主程序）
CMD ["python", "/usr/src/app/main.py"]
