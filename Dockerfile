# 使用Node.js LTS版本作为基础镜像
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 复制依赖定义文件
COPY package*.json ./

# 安装依赖（补充编译工具）
RUN apk add --no-cache python3 make g++ && \
    npm install --omit=dev --ignore-scripts && \
    apk del python3 make g++

# 复制项目文件
COPY . .

# 创建数据存储目录
RUN mkdir -p /app/data

# 暴露端口
EXPOSE 9763

# 设置环境变量
ENV NODE_ENV=production \
    PORT=9763 \
    DATA_DIR=/app/data

# 修正后的启动命令（使用server脚本）
CMD ["npm", "run", "server"]

# 定义数据卷
VOLUME ["/app/data"]
