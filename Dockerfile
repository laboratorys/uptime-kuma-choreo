FROM docker.io/louislam/uptime-kuma:latest AS app-donor

FROM alpine

# https://security.alpinelinux.org/vuln/CVE-2021-46848
RUN apk add --upgrade libtasn1-progs

RUN apk add --no-cache nodejs npm git curl jq tar libc6-compat

# https://security.alpinelinux.org/vuln/CVE-2022-37434
RUN apk update && apk upgrade zlib

# set timezone Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# Create a new user with UID 10014
RUN addgroup -g 10014 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser

USER 10014

# Add Spring Boot app.jar to Container
COPY --from=app-donor /app /app

WORKDIR /app/extra
RUN ls -n
RUN rm -rf healthcheck
ADD healthcheck .
RUN ls -n
EXPOSE 3001
WORKDIR /app
VOLUME ["/app/data"]
CMD ["sh", "-c", "node server/server.js"]
