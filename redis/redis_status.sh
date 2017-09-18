#!/bin/bash
R_PORT="$1"  #根据实际情况调整端口

R_COMMAND="$2"

R_SERVER="192.168.0.7"  #根据具体情况调整IP地址

PASSWD=""       #如果没有设置Redis密码,为空即可

redis_status(){
#   (echo -en "AUTH $PASSWD\r\nINFO\r\n";sleep 1;) | /usr/bin/nc "$R_SERVER" "$R_PORT" > /tmp/redis_"$R_PORT".tmp
#      REDIS_STAT_VALUE=$(grep "$R_COMMAND:" /tmp/redis_"$R_PORT".tmp | cut -d ':' -f2)
#       echo "$REDIS_STAT_VALUE"
   REDIS_STAT_VALUE=$((echo info; sleep 1) | /usr/local/bin/redis-cli -p $1 -h $R_SERVER  | grep -w $2 | awk -F":" '{print $2}')
	   echo "$REDIS_STAT_VALUE"
}

case $R_COMMAND in
    used_cpu_user_children)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    used_cpu_sys)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    total_commands_processed)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    role)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    lru_clock)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    latest_fork_usec)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    keyspace_misses)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    keyspace_hits)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    keys)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    expires)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    expired_keys)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    evicted_keys)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    connected_clients)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    changes_since_last_save)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    blocked_clients)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    bgsave_in_progress)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    bgrewriteaof_in_progress)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    used_memory_peak)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    used_memory)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    used_cpu_user)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    used_cpu_sys_children)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    total_connections_received)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    uptime_in_seconds)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    uptime_in_days)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    *)
    echo $"USAGE:$0 {uptime_in_seconds|uptime_in_days|used_cpu_user_children|used_cpu_sys|total_commands_processed|role|lru_clock|latest_fork_usec|keyspace_misses|keyspace_hits|keys|expires|expired_keys|connected_clients|changes_since_last_save|blocked_clients|bgrewriteaof_in_progress|used_memory_peak|used_memory|used_cpu_user|used_cpu_sys_children|total_connections_received}"
    esac
