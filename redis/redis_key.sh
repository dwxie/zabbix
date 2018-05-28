#!/bin/bash

PORT=`sudo /bin/cat /etc/redis.conf |grep port|awk '{print $NF}'`
PASSWD=`sudo /bin/cat /etc/redis.conf |grep requirepass|awk '{print $NF}'`

#Redis_Key=camera:messages:203.195.157.248
Redis_Key=camera:messages:$1
Redis_Value=`(echo select 0;echo llen $Redis_Key) |/usr/local/bin/redis-cli -p $PORT -a $PASSWD|awk 'END {print}'`
echo $Redis_Value
