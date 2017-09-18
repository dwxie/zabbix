#!/bin/bash
R_PORT="$1"  #根据实际情况调整端口

R_COMMAND="$2"

R_SERVER="192.168.0.7"  #根据具体情况调整IP地址

PASSWD=""       #如果没有设置Redis密码,为空即可

redis_status(){
#   (echo -en "AUTH $PASSWD\r\nINFO\r\n";sleep 1;) | /usr/bin/nc "$R_SERVER" "$R_PORT" > /tmp/redis_"$R_PORT".tmp
#      REDIS_STAT_VALUE=$(grep "$R_COMMAND:" /tmp/redis_"$R_PORT".tmp | cut -d ':' -f2)
#       echo "$REDIS_STAT_VALUE"
   REDIS_STAT_VALUE=$((echo cluster info; sleep 1) | /usr/local/bin/redis-cli -p $1 -h $R_SERVER  | grep -w $2 | awk -F":" '{print $2}')
           echo "$REDIS_STAT_VALUE"
}

case $R_COMMAND in
    cluster_state)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    cluster_stats_messages_sent)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    cluster_stats_messages_received)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    cluster_slots_pfail)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    cluster_slots_fail)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    *)
    echo $"USAGE:$0 {cluster_state| cluster_stats_messages_sent|cluster_stats_messages_received|cluster_slots_pfail|cluster_slots_fail"}
    esac
