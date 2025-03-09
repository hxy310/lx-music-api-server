# 使用Node.js官方镜像作为基础
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY package*.json ./
COPY . .

# 安装依赖并构建（根据项目需求调整）
RUN npm install --production

# 暴露端口（根据项目实际端口修改）
EXPOSE 9527

# 启动命令（根据项目实际启动命令修改）
CMD ["npm", "start"]
