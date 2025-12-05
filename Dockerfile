# ============================
# Builder 阶段：安装 uv 并安装依赖
# ============================
FROM python:3.10-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH=/root/.local/bin:$PATH \
    UV_VENV_PATH=/root/.local \
    UV_PYTHON_PREFERENCE=python-build

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl build-essential ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 安装 uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 只复制依赖文件（不要复制 .venv）
COPY pyproject.toml uv.lock /app/

# 使用 uv 安装项目依赖到 /root/.local
RUN uv sync --no-dev

# 再复制源码（不包含 .venv）
COPY api /app/api
COPY server /app/server
COPY utils /app/utils
COPY crypt /app/crypt
COPY middleware /app/middleware
COPY modules /app/modules
COPY res /app/res
COPY static /app/static
COPY clean.py /app/clean.py
COPY main.py /app/main.py

# ============================
# Runtime 阶段：干净运行
# ============================
FROM python:3.10-slim AS runtime

ENV PATH=/root/.local/bin:$PATH \
    UV_VENV_PATH=/root/.local \
    UV_PYTHON_PREFERENCE=python-build

WORKDIR /app

# 复制 uv 安装好的依赖
COPY --from=builder /root/.local /root/.local

# 复制源码
COPY --from=builder /app /app

# 创建非 root 用户
RUN useradd -m appuser || true \
 && chown -R appuser:appuser /app
USER appuser

# 暴露端口
EXPOSE 9763

# 健康检查
HEALTHCHECK CMD curl -fsS http://127.0.0.1:9763/ || exit 1

# 默认启动命令
CMD ["uv", "run", "main.py"]
