#!/bin/sh -e

config=/app/surgio.conf.js

if [ -n "$(cat $config | grep example.com)" ]; then
  printf "请输入接口域名："
  read -r urlBase
fi

if [ -n "$(cat $config | grep admin)" ]; then
  printf "请设置接口密码："
  read -r passwd
fi

sed -i "s/example.com/$urlBase/g" $config
sed -i "s/admin/$passwd/g" $config
rm -f /app/go.sh
