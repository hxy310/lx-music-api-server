# Dockerfile
FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    UV_INSTALL_DIR=/usr/local/bin \
    UV_NO_MODIFY_PATH=1 \
    PATH=/usr/local/bin:$PATH

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 复制项目代码
COPY . /app

# 安装 Python 依赖（优先 requirements.txt）
RUN if [ -f "requirements.txt" ]; then \
      pip install --upgrade pip && pip install -r requirements.txt; \
    elif [ -f "pyproject.toml" ]; then \
      pip install --upgrade pip && pip install poetry && poetry config virtualenvs.create false && poetry install --no-dev --no-interaction; \
    fi

# 安装 uv 到 /usr/local/bin（UV_INSTALL_DIR 已设置），并确保可执行
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && if [ -f "/root/.local/bin/uv" ] && [ ! -f "/usr/local/bin/uv" ]; then \
         ln -s /root/.local/bin/uv /usr/local/bin/uv || true; \
       fi \
    || true

# 在镜像构建时尝试 uv sync（失败不阻塞构建）
RUN uv sync || true

# 暴露端口
EXPOSE 9763

# 挂载点，供外部挂载配置
VOLUME ["/app/config"]

# 启动命令：优先使用 uv，如果 uv 不可用则回退到 python
CMD ["sh", "-c", "if command -v uv >/dev/null 2>&1; then uv run main.py; else python main.py; fi"]
