# 使用与 GitHub Actions 一致的 Node.js 版本（根据项目要求选择）
FROM node:18-alpine

# 设置容器工作目录（与 Actions 的 checkout 路径对应）
WORKDIR /app

# 1. 复制依赖文件（利用 Docker 层缓存优化）
COPY package.json package-lock.json* ./

# 2. 安装依赖（匹配 Actions 中的依赖安装逻辑）
# 若项目使用 pnpm，需调整安装命令
RUN npm install --production --silent

# 3. 复制项目源代码（排除非必要文件）
COPY . .

# 4. 声明容器端口（与 Actions 服务端口一致）
EXPOSE 9763

# 5. 设置容器启动命令（与 Actions 部署逻辑匹配）
CMD ["npm", "start"]
