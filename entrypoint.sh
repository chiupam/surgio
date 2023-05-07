#!/bin/sh -e

start() {
  path="/app/node_modules"
  if [ ! -d "/app/.git" ]; then
    echo "未检测到 surgio 仓库, 正在克隆中, 请耐心等待..."
    git clone https://github.com/chiupam/surgio.git /app >/dev/null 2>&1
    git -C /app fetch --all >/dev/null 2>&1
    git -C /app checkout main >/dev/null 2>&1
    rm -rf /app/.idea >/dev/null 2>&1
    rm -rf /app/.github >/dev/null 2>&1
    rm -rf $(ls | egrep -v "go|js|node|provider|template") >/dev/null 2>&1
  fi
  if [ ! -d "$path/surgio/" ]; then
    echo "未检测到 surgio 依赖, 正在安装中, 请耐心等待..."
    npm install surgio@latest >/dev/null 2>&1
    rm -f /app/package*.json >/dev/null 2>&1
  fi
  if [ ! -d "$path/@surgio/gateway" ]; then
    echo "未检测到 gateway 依赖, 正在安装中, 请耐心等待..."
    npm install @surgio/gateway@latest >/dev/null 2>&1
    rm -f /app/package*.json >/dev/null 2>&1
  fi
  echo "初始化完成, 正在启动中, 监听文件如有更新则自动重启服务..."
  pm2-runtime start /app/ecosystem.config.js
}

start
