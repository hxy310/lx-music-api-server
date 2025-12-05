# 使用官方 Python 3.11 slim 镜像，轻量且包含 Python 3.10+
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 安装必要依赖（curl, git 用于 uv 安装）
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 安装 uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 将项目文件复制到容器中
COPY . /app

# 同步 uv 环境
RUN uv sync

# 暴露服务端口
EXPOSE 9763

# 配置挂载目录（默认 config 文件夹）
VOLUME ["/app/config"]

# 启动服务
CMD ["uv", "run", "main.py"]
