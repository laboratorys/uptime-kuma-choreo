#!/bin/sh
/app/backup2gh
##sleep 5
#retry_count=0
#max_retries=30
#while [ $retry_count -lt $max_retries ]; do
#    if [ -f "/app/restore.lock" ]; then
#        echo "$(date "+%Y-%m-%d %H:%M:%S") Waiting for restore from github..."
#        sleep 5
#        ((retry_count++))
#    else
#        break
#    fi
#done
#echo "$(date "+%Y-%m-%d %H:%M:%S") Starting uptime-kuma server..."
#node server/server.js
