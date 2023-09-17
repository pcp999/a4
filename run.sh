#!/bin/bash
cd `dirname $0`
PATH=$PATH:/usr/local/bin
# 休眠随机时间0-99s
sleep 1
python3 gettime.py >> data.txt
echo "date,action" > data.csv
tac data.txt >> data.csv
