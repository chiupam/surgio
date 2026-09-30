FROM alpine:3.22

ENV NODE_ENV=production TZ=Asia/Shanghai LANG=C.UTF-8

WORKDIR /opt/surgio

# 先安装依赖(与 app/ 内容无关), 这样改动模板/配置不会使 npm install 缓存失效
RUN set -ex \
    && apk add --no-cache nodejs npm tzdata \
    && npm install --omit=dev --no-audit --no-fund surgio@^3 @surgio/gateway@^2 \
    && npm cache clean --force \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo "$TZ" > /etc/timezone

COPY app/ /opt/surgio/
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

ENV SURGIO_PROJECT_DIR=/app

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
    CMD wget -qO- http://127.0.0.1:3000/ >/dev/null 2>&1 || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
