# 使用 Node.js 官方镜像作为基础镜像（根据项目要求选择版本，例如 16-alpine）
FROM node:16-alpine

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器（排除 node_modules 和构建无关文件）
COPY package*.json ./
COPY . .

# 安装依赖（根据项目需求调整命令，如使用 npm 或 yarn）
RUN npm install --production

# 暴露应用端口（根据项目实际端口调整）
EXPOSE 9527

# 启动命令（根据项目启动脚本调整）
CMD ["npm", "start"]
