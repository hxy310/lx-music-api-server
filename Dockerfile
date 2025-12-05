# 使用官方 Python 3.10 精简镜像
FROM python:3.10-slim

# 环境优化
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH=/root/.local/bin:$PATH

WORKDIR /app

# 安装系统依赖（尽量精简），并清理缓存
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# 复制依赖文件并安装 Python 依赖
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# 复制代码
COPY . /app

# 创建非 root 用户并设置权限
RUN useradd -m appuser || true \
 && chown -R appuser:appuser /app

USER appuser

# 暴露应用端口（与你要求一致）
EXPOSE 9763

# 可选：简单健康检查（若需要可以改为更具体的 URL）
HEALTHCHECK --interval=30s --start-period=10s --retries=3 \
  CMD curl -fsS http://127.0.0.1:9763/ || exit 1

# 默认启动命令 —— 如果仓库需要使用 uv 启动或特殊参数可在这里改动
CMD ["uv", "run", "main.py"]
