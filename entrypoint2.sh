#!/bin/sh
run_backup(){
  if [[ -n "$BAK_APP_NAME" || -n "${BAK_APP_NAME}" ]]; then
      b_path="download/${BAK_VERSION-"latest"}"
       if [ "${BAK_VERSION-"latest"}" = "latest" ]; then
         b_path="latest/download"
       fi
       cd /app
       echo "$(date "+%Y-%m-%d %H:%M:%S") Downloading backup2gh..."
       curl -s -L "https://github.com/laboratorys/backup2gh/releases/latest/download/backup2gh-linux-amd64.tar.gz" -o backup2gh.tar.gz \
           && tar -xzf backup2gh.tar.gz \
           && rm backup2gh.tar.gz \
           && chmod +x backup2gh \
           && ls -n

  fi
}
run_backup
./backup2gh
