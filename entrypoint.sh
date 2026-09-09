#!/bin/sh -e

APP_DIR="${SURGIO_PROJECT_DIR:-/app}"
SRC_DIR="/opt/surgio"

# 生成 24 位随机 token
gen_token() {
  node -e "process.stdout.write(require('crypto').randomBytes(12).toString('hex'))"
}

# 鉴权信息缺省时自动生成并打印到日志
if [ -z "$SURGIO_WEB_TOKEN" ]; then
  SURGIO_WEB_TOKEN=$(gen_token)
  export SURGIO_WEB_TOKEN
  echo "未设置 SURGIO_WEB_TOKEN(面板密码), 已自动生成: $SURGIO_WEB_TOKEN"
fi

if [ -z "$SURGIO_VIEWER_TOKEN" ]; then
  SURGIO_VIEWER_TOKEN=$(gen_token)
  export SURGIO_VIEWER_TOKEN
  echo "未设置 SURGIO_VIEWER_TOKEN(订阅接口密码), 已自动生成: $SURGIO_VIEWER_TOKEN"
fi

# 初始化用户目录: 仅播种缺失的文件, 不覆盖已有配置
mkdir -p "$APP_DIR"
for item in surgio.conf.js provider template; do
  if [ ! -e "$APP_DIR/$item" ]; then
    echo "初始化 $item ..."
    cp -a "$SRC_DIR/$item" "$APP_DIR/"
  fi
done

# 旧版本在卷内安装过依赖, 替换为软链以复用镜像内依赖
if [ -e "$APP_DIR/node_modules" ] && [ ! -L "$APP_DIR/node_modules" ]; then
  echo "检测到旧版 node_modules, 替换为软链..."
  rm -rf "$APP_DIR/node_modules"
fi
if [ ! -e "$APP_DIR/node_modules" ]; then
  ln -s "$SRC_DIR/node_modules" "$APP_DIR/node_modules"
fi

cd "$APP_DIR"

echo "Surgio 服务启动中, 配置与模板更新会自动重启服务..."
exec node --watch-path=./template --watch-path=./provider --watch "$SRC_DIR/gateway.js"
