FROM python:3.10-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH=/root/.local/bin:$PATH

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl build-essential ca-certificates \
    && rm -rf /var/lib/apt/lists/*


# ============================
# 安装 uv + 项目依赖
# ============================
FROM base AS builder

# 安装 UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 拷贝项目文件
COPY . /app

# 使用 uv 安装 pyproject.toml 里的依赖
RUN uv sync --no-dev


# ============================
# 运行环境镜像（干净）
# ============================
FROM python:3.10-slim AS runtime

ENV PATH=/root/.local/bin:$PATH
WORKDIR /app

# 拷贝运行所需环境
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app /app

# 创建非 root 用户
RUN useradd -m appuser || true \
 && chown -R appuser:appuser /app
USER appuser

# 暴露端口（与你项目一致）
EXPOSE 9763

# 健康检查
HEALTHCHECK CMD curl -fsS http://127.0.0.1:9763/ || exit 1

# 运行应用（你的项目正确启动方式）
CMD ["uv", "run", "main.py"]
