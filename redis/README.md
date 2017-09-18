# Redis  Cluster监控方案

由于zabbix自带模版只能监控单示例redsi，对于多端口的redis clustaer的监控不太方便，所以重新自定义监控项、监控模版。本案使用3个脚本来获取redis相关信息。

### 1、redis_sport_scan.sh

本脚本用于自动探测服务器上监听的redis端口（可根据实际情况修改脚本，通用也可以用于探测其他服务端口如：mongo，tomcat），并将json格式结果传递给zabbix server端。

脚本内容如下：可手动执行脚本，测试脚本正确性。

其中netstat命令需要root权限，所以要给zabbix这个用户授权，否则会需不到键值！

echo "zabbix ALL=(root) NOPASSWD:/bin/netstat">>/etc/sudoers

ccentos还需：sed -i 's/^Defaults.*.requiretty/#Defaults    requiretty/'/etc/sudoers



```
#!/bin/bash
redis() {
            port=($(sudo netstat -tpln | awk -F "[ :]+" '/redis/ && /0.0.0.0/ {print $5}' | grep -v ^1))
            printf '{\n'
            printf '\t"data":[\n'
               for key in ${!port[@]}
                   do
                       if [[ "${#port[@]}" -gt 1 && "${key}" -ne "$((${#port[@]}-1))" ]];then

              socket=`ps aux|grep ${port[${key}]}|grep -v grep|awk -F '=' '{print $10}'|cut -d ' ' -f 1`
                          printf '\t {\n'
                          printf "\t\t\t\"{#REDISPORT}\":\"${port[${key}]}\"},\n"
                     else [[ "${key}" -eq "((${#port[@]}-1))" ]]
              socket=`ps aux|grep ${port[${key}]}|grep -v grep|awk -F '=' '{print $10}'|cut -d ' ' -f 1`
                          printf '\t {\n'
                          printf "\t\t\t\"{#REDISPORT}\":\"${port[${key}]}\"}\n"
                       fi
               done
                          printf '\t ]\n'
                          printf '}\n'
}
redis $1
```



### 2、redis_status.sh

本脚本用于获取redis相关参数值，并传递给zabbix server端对应的监控项，参数取值来源于redis内部命令INFO。

也可以不用脚本直接用命令的方式来获取。

```
UserParameter=redis.status[*],(echo info; sleep 1) | /usr/local/bin/redis-cli -a redis -p $1 2>&1 |grep -w $2|cut -d : -f2
```

脚本内容如下：（参数根据实际情况调整）

```
#!/bin/bash
R_PORT="$1"  #根据实际情况调整端口
R_COMMAND="$2"
R_SERVER=`hostname -I`  #根据具体情况调整IP地址
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
```



### 3、redis_cluster_status.sh

本脚本用于获取redis cluster相关参数，数据来源redis 内部命令CLUSTER INFO，取值方式类似与redis_status.sh，参数可根据实际需要调整

脚本内容：

```
#!/bin/bash
R_PORT="$1"  #根据实际情况调整端口
R_COMMAND="$2"
R_SERVER=`hostname -I`  #根据具体情况调整IP地址
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
```



### 4、zabbix-agent配置文件

```
UserParameter=redis.port,/bin/bash /etc/zabbix/scripts/redis_sport_scan.sh
UserParameter=redis.status[*],/bin/bash	/etc/zabbix/scripts/redis_status.sh $1 $2
UserParameter=cluster.status[*],/etc/zabbix/scripts/redis_cluster_status.sh $1 $2
```



### 5、根据脚本里面的取值参数去zabbix server端 添加监控项，并生成模版（LD_Redis-cluster.xml）