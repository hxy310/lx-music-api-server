# 使用Node.js LTS版本作为基础镜像
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 复制依赖定义文件（利用Docker层缓存机制）
COPY package*.json ./

# 安装依赖（使用npm的纯依赖模式）
RUN npm install --omit=dev --ignore-scripts

# 复制项目文件
COPY . .

# 创建数据存储目录（用于卷挂载）
RUN mkdir -p /app/data

# 暴露端口（与项目配置保持一致）
EXPOSE 9763

# 设置环境变量
ENV NODE_ENV=production \
    PORT=9527 \
    DATA_DIR=/app/data

# 启动命令
CMD ["npm", "start"]

# 定义数据卷（方便持久化数据）
VOLUME ["/app/data"]
