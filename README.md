# surgio

[**Surgio官网**](https://surgio.js.org/guide.html)

依赖已内置于镜像中，启动即用。配置通过环境变量注入，`/app` 卷内为用户可编辑文件（`surgio.conf.js`、`provider/`、`template/`），修改后服务自动重启。

## Docker

```shell
docker run -dit \
  --name surgio \
  --restart unless-stopped \
  --hostname surgio \
  -e SURGIO_WEB_TOKEN=your-password \
  -v $PWD/surgio:/app \
  -p 3000:3000 \
  chiupam/surgio:latest
```

## Docker-compose

```shell
docker-compose up -d
```

compose 文件示例见仓库根目录。

## 环境变量

| 变量 | 说明 | 缺省行为 |
| --- | --- | --- |
| `SURGIO_WEB_TOKEN` | 面板登录密码 | 仅当配置启用 `auth: true` 时自动生成 |
| `SURGIO_VIEWER_TOKEN` | 订阅接口鉴权码（`/get-artifact` 等） | 仅当配置启用 `auth: true` 时自动生成 |
| `SURGIO_URL_BASE` | 对外访问地址 | `http://localhost:3000/` |
| `PORT` | 服务监听端口 | `3000` |

内网部署且未启用面板鉴权（`auth: false`）时，无需关心任何 token，日志中也不会出现相关输出。

查看自动生成的密码：

```shell
docker logs surgio | grep "已自动生成"
```

## 数据持久化

首次启动时，容器会把默认的 `surgio.conf.js`、`provider/`、`template/` 播种到 `/app` 卷中（仅播种缺失的文件，不覆盖已有配置）。之后直接编辑卷内文件即可：

- 修改 `provider/`（订阅）或 `template/`（模板）：自动重启生效
- 修改 `surgio.conf.js`（artifacts 列表等）：自动重启生效

## 从旧版本升级

旧版本会在卷内安装 `node_modules`，新版启动时会自动将其替换为指向镜像内依赖的软链，无需手动处理。旧版通过 `start.sh` 写入配置的方式已废弃，改为通过环境变量 `SURGIO_WEB_TOKEN` 等注入；如需切换，删除卷内的 `surgio.conf.js` 后重启容器即可重新播种。
