#!/bin/bash
run_backup(){
  nohup /app/backup2gh > /dev/null 2>&1 &
}
run_backup
sleep 30
node server/server.js