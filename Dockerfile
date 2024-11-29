FROM alpine AS builder
RUN apk add --no-cache nodejs npm git curl jq tar libc6-compat

RUN npm install npm -g

RUN adduser -D 10014
USER 10014
WORKDIR /home/10014

#ARG BAK_VERSION=1.8
#ENV BAK_VERSION=${BAK_VERSION}
#RUN curl -L "https://github.com/laboratorys/backup-to-github/releases/download/v${BAK_VERSION}/backup2gh-v${BAK_VERSION}-linux-amd64.tar.gz" --create-dirs -o /home/10014/backup-to-github.tar.gz \
#    && cd $WORKDIR && ls -n && tar -xzf /home/10014/backup-to-github.tar.gz \
#    && rm /home/10014/backup-to-github.tar.gz
ADD backup2gh backup2gh
ADD src /home/10014/uptime-kuma

#RUN git clone https://github.com/louislam/uptime-kuma.git
WORKDIR /home/10014/uptime-kuma
RUN npm run setup

EXPOSE 3001
CMD ["sh", "-c", "node server/server.js"]
