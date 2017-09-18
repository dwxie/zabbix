#!/bin/bash
#This script is used to get discovered  mongodb servers status
 
#echo "db.serverStatus().uptime"|mongo 192.168.0.8:27017/admin  -uroot -pxxxx
#echo "db.serverStatus().mem.mapped"|mongo 192.168.0.8:27017/admin  -uroot -pxxx
#echo "db.serverStatus().globalLock.activeClients.total"|mongo 192.168.0.8:27017/admin  -uroot -pxxx
# Macro {#MONGO_INFO}  "HOSTNAME:PORT:USERNAME:PASSWORD"
#sh discovery_mongodb_status.sh  uptime  {#MONGO_HOST} 
#sh discovery_mongodb_status.sh  mem mapped  {#MONGO_HOST} 
#sh discovery_mongodb_status.sh  globalLock activeClients total  {#MONGO_HOST} 
#one more parameter
 
mongo_info=""
command_line=""
 
function check_mongo_info() {
 
    num=$(echo $mongo_info|awk -F":" '{print NF}')
    host=$(echo $mongo_info|awk -F":" '{print $1}')
    port=$(echo $mongo_info|awk -F":" '{print $2}')
    username=$(echo $mongo_info|awk -F":" '{print $3}')
    password=$(echo $mongo_info|awk -F":" '{print $4}')
    
    case $num in
     2)
       command_line="/usr/bin/mongo $host:$port/admin"
       ;;
     3)
       command_line="/usr/bin/mongo $host:$port/admin -u$username -p''"
       ;;
     4)
       command_line="/usr/bin/mongo $host:$port/admin -u$username -p$password"
       ;;
     esac
             
                            }
case $# in
  2)    
    mongo_info=$(grep $2 /etc/zabbix/scripts/mongodb_servers.txt)
    check_mongo_info 
    output=$(/bin/echo "db.serverStatus().$1" |$command_line|sed -n '4p')
    ;;
  3)
    mongo_info=$(grep $3 /etc/zabbix/scripts/mongodb_servers.txt)
    check_mongo_info
    output=$(/bin/echo "db.serverStatus().$1.$2" |$command_line|sed -n '4p')
    ;;
  4)
    mongo_info=$(grep $4 /etc/zabbix/scripts/mongodb_servers.txt)
    check_mongo_info
    output=$(/bin/echo "db.serverStatus().$1.$2.$3" |$command_line|sed -n '4p')
    ;;
esac
 
#check if the output contains "NumberLong"
if [[ "$output" =~ "NumberLong"   ]];then
  echo $output|sed -n 's/NumberLong(//p'|sed -n 's/)//p'
else 
  echo $output
fi
