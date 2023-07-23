#!/bin/bash -e

config=/app/surgio.conf.js

# 显示参考格式
echo "域名格式：example.com IP格式：192.168.1.1"

# 获取接口地址
read -e -p "请输入接口地址：" -r urlBase

# 检查接口地址是否为空
if [ -z "$urlBase" ]; then
  echo "接口地址不能为空！"
  exit 1
fi

# 判断输入的接口地址是否为IP地址
if echo "$urlBase" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
  # 输入的是IP地址，需要用户输入端口号
  read -e -p "请输入端口号：" -r port
  # 检查端口号是否为空
  if [ -z "$port" ]; then
    echo "端口号不能为空！"
    exit 1
  fi
  urlBase="http://$urlBase:$port"
else
  # 输入的是域名，使用https
  urlBase="https://$urlBase"
fi

# 获取面板登录密码
read -e -p "请设置面板登录密码：" -r webToken

# 检查面板登录密码是否为空
if [ -z "$webToken" ]; then
  echo "面板登录密码不能为空！"
  exit 1
fi

# MD5生成随机接口密码
random_password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 12 | xargs)
artifactToken=$(echo -n "$random_password" | md5sum | awk '{print $1}')

# 处理URL中的特殊字符
escaped_urlBase=$(printf '%s\n' "$urlBase" | sed -e 's/[\/&]/\\&/g')
escaped_passwd=$(echo "$webToken" | sed -e 's/[\/&]/\\&/g')
escaped_token=$(echo "$artifactToken" | sed -e 's/[\/&]/\\&/g')

# 替换urlBase和接口密码
if grep -q "https://example.com" "$config"; then
  # 使用转义字符处理可能包含特殊字符的接口地址和密码
  sed -i "s|https://example.com|$escaped_urlBase|g; s|webToken|$escaped_passwd|g; s|artifactToken|$escaped_token|g" "$config"
  echo -e "\n面板地址：$urlBase/"
  echo "面板密码：$webToken"
  echo -e "接口密码：$artifactToken\n"
  echo "自动重启服务中……"
fi

rm "$0"
