# ============================
# 基础构建镜像
# ============================
FROM python:3.10-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH=/root/.local/bin:$PATH

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl build-essential ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 安装 UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 只复制必要文件（避免 .venv 被复制）
COPY pyproject.toml uv.lock /app/

# 先创建虚拟环境并安装依赖
RUN uv sync --no-dev

# 再复制项目源码（不要复制 .venv）
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
# 运行环境
# ============================
FROM python:3.10-slim AS runtime

ENV PATH=/root/.local/bin:$PATH
WORKDIR /app

# 复制 uv 构建出的依赖环境
COPY --from=builder /root/.local /root/.local

# 复制应用代码
COPY --from=builder /app /app

# 运行用户
RUN useradd -m appuser || true \
 && chown -R appuser:appuser /app
USER appuser

# 端口
EXPOSE 9763

# 健康检查
HEALTHCHECK CMD curl -fsS http://127.0.0.1:9763/ || exit 1

# 入口命令
CMD ["uv", "run", "main.py"]
