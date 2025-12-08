# 使用官方推荐的基于 Debian 的 Python 镜像
FROM python:3.11-slim-bookworm

# 设置工作目录
WORKDIR /app

# 1. 安装 UV 包管理器 (从官方镜像复制二进制文件)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# 2. 配置 UV 环境变量
# UV_SYSTEM_PYTHON=1 让 uv 直接安装库到系统 python 环境中，减小镜像体积
# 也可以选择创建虚拟环境，但在 Docker 中直接安装到系统层通常更简便
ENV UV_COMPILE_BYTECODE=1 \
    UV_link_mode=copy \
    PYTHONUNBUFFERED=1

# 3. 复制依赖定义文件
# 这样做的好处是：只要依赖没变，Docker 就会使用缓存，无需重新下载
COPY pyproject.toml uv.lock ./

# 4. 同步环境 (安装依赖)
# --frozen 确保严格按照 uv.lock 安装，不进行隐式更新
# --no-install-project 仅安装依赖，暂不安装项目本身
RUN uv sync --frozen --no-install-project

# 5. 复制项目源代码
COPY . .

# 6. 暴露端口
EXPOSE 9763

# 7. 启动命令
# 必须使用 uv run 启动，以确保环境上下文正确
CMD ["uv", "run", "main.py"]
