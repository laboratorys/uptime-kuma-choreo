FROM docker.io/louislam/uptime-kuma:1-alpine AS app-donor

FROM alpine

RUN apk add --upgrade libtasn1-progs

RUN apk add --no-cache nodejs npm git curl jq tar libc6-compat

RUN apk update && apk upgrade zlib

RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

RUN addgroup -g 10014 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser

COPY --from=app-donor /app /app
RUN cd /app && curl -L "https://github.com/laboratorys/backup2gh/releases/latest/download/backup2gh-linux-amd64.tar.gz" -o backup2gh.tar.gz \
    && tar -xzf backup2gh.tar.gz \
    && rm backup2gh.tar.gz \
    && chmod +x /app/backup2gh \
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
RUN mkdir -p /app/data/upload && \
    chown -R 10014:10014 /app/data && \
    chmod -R 755 /app/data
USER 10014
EXPOSE 3001
WORKDIR /app
VOLUME ["/app/data"]
ENTRYPOINT ["bash", "/app/entrypoint.sh"]