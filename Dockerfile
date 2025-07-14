FROM docker.io/louislam/uptime-kuma:latest AS app-donor

FROM debian:slim

RUN apt-get update && apt-get install -y \
    libtasn1-bin \
    nodejs \
    npm \
    git \
    curl \
    jq \
    tar \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apt-get purge -y tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 10014 choreo && \
    useradd -r -u 10014 -g choreo -s /bin/false choreouser

COPY --from=app-donor /app /app
RUN cd /app && curl -L "https://github.com/laboratorys/backup2gh/releases/latest/download/backup2gh-linux-amd64.tar.gz" -o backup2gh.tar.gz \
    && tar -xzf backup2gh.tar.gz \
    && rm backup2gh.tar.gz \
    && chmod +x /app/backup2gh
USER 10014
EXPOSE 3001
WORKDIR /app
VOLUME ["/app/data"]
CMD ["sh", "-c", "nohup /app/backup2gh & node server/server.js"]