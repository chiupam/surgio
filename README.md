# surgio

[**Surgio官网**](https://surgio.js.org/guide.html)

## Docker

```shell
docker run -dit \
  --name surgio \
  --restart unless-stopped \
  --hostname surgio \
  -v $PWD/surgio:/app \
  -p 3000:3000 \
  chiupam/surgio:latest
```

## Docker-compose
```shell
cat > ./docker-compose.yml << EOF
version: "2.0"
services:
  surgio:
    image: chiupam/surgio:latest
    container_name: surgio
    restart: unless-stopped
    hostname: surgio
    volumes:
      - $PWD/surgio:/app
    ports:
      - 3000:3000
EOF
docker-compose up -d
```

## 初始化设置
```shell
docker exec -it surgio start.sh
```