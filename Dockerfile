# 使用官方 Python 3.8 镜像作为基础
FROM python:3.8-slim

# 设置工作目录
WORKDIR /app

# 复制依赖列表并安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制项目所有文件到容器
COPY . .

# 声明数据卷（用于持久化数据）
VOLUME /app/data

# 暴露项目端口
EXPOSE 9763

# 设置容器启动命令
CMD ["python", "main.py"]
