# 1. 基础镜像：使用官方 Python 3.9 轻量版
FROM python:3.9-slim

# 2. 设置工作目录
WORKDIR /app

# 3. 设置时区为上海，防止日志时间错乱
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 4. 复制依赖清单并安装
# 使用阿里云镜像源加速安装依赖，提高构建成功率
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

# 5. 复制项目的所有代码到镜像中
COPY . .

# 6. 预创建配置目录和日志目录 (这是关键，确保挂载点存在)
RUN mkdir -p /app/config /app/logs

# 7. 声明数据卷，明确告诉 Docker 这些目录是用来存数据的
VOLUME ["/app/config", "/app/logs"]

# 8. 暴露端口
EXPOSE 9763

# 9. 启动命令
CMD ["python", "main.py"]
