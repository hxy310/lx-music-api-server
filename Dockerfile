# 基础镜像，带 Python 3.11
FROM python:3.11-slim

# 安装依赖
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . /app

# 安装 uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 将 uv 可执行文件加入 PATH
ENV PATH="/root/.uv/bin:${PATH}"

# 同步 uv 环境
RUN uv sync

# 暴露端口
EXPOSE 9763

# 配置挂载点
VOLUME ["/app/config"]

# 启动命令
CMD ["uv", "run", "main.py"]
