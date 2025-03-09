# Dockerfile for lx-music-api-server
# 使用官方Python 3.8镜像作为基础
FROM python:3.8-slim

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器（建议先创建.dockerignore文件排除不需要的文件）
COPY . .

# 安装项目依赖（使用清华PyPI镜像加速）
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 声明需要持久化的目录
VOLUME ["/app/audio", "/app/config", "/app/logs", "/app/temp"]

# 暴露服务端口
EXPOSE 9763

# 设置容器启动命令
CMD ["python", "main.py"]
