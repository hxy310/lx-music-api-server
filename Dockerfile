# Dockerfile
FROM python:3.10-slim

# 环境变量，避免 Python 输出缓冲
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    UV_HOME=/root/.uv

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 安装 uv（按官方安装脚本）
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 工作目录
WORKDIR /app

# 复制项目代码
COPY . /app

# 如果项目有 requirements.txt 或 pyproject.toml/poetry.lock，优先安装依赖
# 兼容多种情况：先尝试 requirements.txt，再尝试 poetry/pyproject
RUN if [ -f "requirements.txt" ]; then \
      pip install --upgrade pip && pip install -r requirements.txt; \
    elif [ -f "pyproject.toml" ]; then \
      pip install --upgrade pip && pip install poetry && poetry config virtualenvs.create false && poetry install --no-dev --no-interaction; \
    fi

# 在镜像构建时同步 uv 环境（如果项目依赖 uv sync）
RUN uv sync || true

# 暴露端口
EXPOSE 9763

# 默认工作目录下的配置目录（供挂载）
VOLUME ["/app/config"]

# 启动命令：使用 uv 运行 main.py，若需要可改为 python main.py
CMD ["uv", "run", "main.py"]
