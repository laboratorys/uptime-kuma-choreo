FROM docker.io/iicm/uptime-kuma-choreo:latest AS app-donor

FROM alpine

RUN apk add --upgrade libtasn1-progs

RUN apk add --no-cache nodejs npm git curl jq tar libc6-compat

RUN apk update && apk upgrade zlib

RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

RUN addgroup -g 10014 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser

USER 10014

COPY --from=app-donor /app /app
ADD ./backup2gh /app/
RUN chmod +x /app/backup2gh
EXPOSE 3001
WORKDIR /app
VOLUME ["/app/data"]
CMD ["sh", "-c", "nohup /app/backup2gh & node server/server.js"]
