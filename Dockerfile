FROM docker.io/louislam/uptime-kuma:latest AS app-donor

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
ARG BAK_VERSION=2.0
RUN cd /app && curl -L "https://github.com/laboratorys/backup-to-github/releases/download/v${BAK_VERSION}/backup2gh-v${BAK_VERSION}-linux-amd64.tar.gz" -o backup-to-github.tar.gz \
    && tar -xzf backup-to-github.tar.gz \
    && rm backup-to-github.tar.gz \
    && chmod +x /app/backup2gh
USER 10014
EXPOSE 3001
WORKDIR /app
VOLUME ["/app/data"]
CMD ["sh", "-c", "nohup /app/backup2gh & node server/server.js"]