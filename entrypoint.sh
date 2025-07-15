#!/bin/sh
run_backup(){
  if [[ -n "$BAK_APP_NAME" || -n "${BAK_APP_NAME}" ]]; then
      b_path="download/${BAK_VERSION-"latest"}"
       if [ "${BAK_VERSION-"latest"}" = "latest" ]; then
         b_path="latest/download"
       fi
       cd /app
       echo "$(date "+%Y-%m-%d %H:%M:%S") Downloading backup2gh..."
       curl -s -L "https://github.com/laboratorys/backup2gh/releases/${b_path}/backup2gh-linux-amd64.tar.gz" -o backup2gh.tar.gz \
           && tar -xzf backup2gh.tar.gz \
           && rm backup2gh.tar.gz \
           && chmod +x /app/backup2gh
       nohup /app/backup2gh > /dev/null 2>&1 &
  fi
}
run_backup
sleep 3
ls -n /app/restore.lock
retry_count=0
max_retries=30
while [ $retry_count -lt $max_retries ]; do
    if [ -f "/app/restore.lock" ]; then
        echo "$(date "+%Y-%m-%d %H:%M:%S") Waiting for restore from github..."
        sleep 5
        ((retry_count++))
    else
        break
    fi
done
echo "$(date "+%Y-%m-%d %H:%M:%S") Starting uptime-kuma server..."
node server/server.js
