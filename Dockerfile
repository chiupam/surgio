FROM alpine:latest

ENV PATH=/usr/local/bin:$PATH LANG=C.UTF-8

WORKDIR /app

COPY ./*.sh /app

RUN set -ex \
&& apk update -f \
&& apk upgrade \
&& apk add --no-cache bash tzdata git npm \
&& rm -rf /var/cache/apk/* \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& npm install -g pm2@latest \
&& mv /app/*.sh /usr/local/bin \
&& chmod +x /usr/local/bin/*.sh

ENTRYPOINT ["entrypoint.sh"]
