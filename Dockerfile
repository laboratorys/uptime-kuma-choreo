FROM docker.io/louislam/uptime-kuma:latest AS app-donor
FROM debian:12-slim

# Install all packages and configure timezone in a single layer
RUN apt-get update && apt-get install -y \
    libtasn1-bin \
    nodejs \
    npm \
    git \
    curl \
    jq \
    tar \
    tzdata \
    && apt-get upgrade -y \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create user and group
RUN groupadd -g 10014 choreo && \
    useradd -r -u 10014 -g choreo -s /bin/false choreouser

# Copy application and set permissions
COPY --from=app-donor /app /app

RUN cd /app && curl -L "https://github.com/laboratorys/backup2gh/releases/latest/download/backup2gh-linux-amd64.tar.gz" -o backup2gh.tar.gz \
    && tar -xzf backup2gh.tar.gz \
    && rm backup2gh.tar.gz \
    && chmod +x /app/backup2gh
COPY entrypoint.sh /app/entrypoint.sh
RUN mkdir -p /app/data/upload && \
    chown -R 10014:10014 /app && \
    chmod -R 755 /app && \
    chmod +x /app/entrypoint.sh

# Runtime configuration
USER 10014
WORKDIR /app
VOLUME ["/app/data"]
EXPOSE 3001
ENTRYPOINT ["bash", "/app/entrypoint.sh"]