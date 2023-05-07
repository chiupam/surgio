#!/bin/sh -e

config=/app/surgio.conf.js

if [ -n "$(cat $config | grep example.com)" ]; then
  read -p "请输入接口地址：" -r urlBase
  sed -i "s/example.com/$urlBase/g" $config
fi

if [ -n "$(cat $config | grep admin)" ]; then
  read -p "请设置接口密码：" -r passwd
  sed -i "s/admin/$passwd/g" $config
fi

rm go.sh
