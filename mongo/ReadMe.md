# 本模版用于监控mongoDB（3.47为例）

## 1、脚本说明

a、mongodb_servers.txt           用于保存mongodb数据库信息，格式为ip: port  :user : passwd （数据库端口、用户名、密码根据实际情况填写）
b、discovery_mongodb_status.sh   获取具体某监控项的值
c、mongodb_discovery.py          zabbix server 获取数据库信息



## 2、脚本内容

#### a、cat mongodb_servers.txt

```
192.168.0.8:27017
```

#### b、vim mongodb_discovery.py

```
#!/usr/bin/python
#This script is used to discovery disk on the server

import subprocess
import json

args='''awk -F':' '{print $1":"$2}' /etc/zabbix/scripts/mongodb_servers.txt'''
t=subprocess.Popen(args,shell=True,stdout=subprocess.PIPE).communicate()[0]
mongodbs=[]

for mongo in t.split('\n'):
    if len(mongo) != 0:
       mongodbs.append({'{#MONGO_HOST}':mongo})
print json.dumps({'data':mongodbs},indent=4,separators=(',',':'))
```

#### c、vim discovery_mongodb_status.sh 

```
#!/bin/bash
#This script is used to get discovered  mongodb servers status

#echo "db.serverStatus().uptime"|mongo 192.168.0.8:27017/admin
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
```



## 3、注意事项：

把上面3个文件放入zabbix目录下，例如/etc/zabbix/scripts （最好先手动执行下各个脚本，看能否获取到值，python 脚本可以直接执行，shell 脚本按照脚本开头的示例执行。）

并在/etc/zabbix/zabbix_agentd.conf.d 添加配置文件（自定义监控项）

```
vim userparameter_mongodb.conf
UserParameter=MongoDB.Discovery,/usr/bin/python /etc/zabbix/scripts/mongodb_discovery.py
UserParameter=MongoDB.Discovery_Status[*],/etc/zabbix/scripts/discovery_mongodb_status.sh $1 $2 $3 $4
```

重启zabbix-agent，并导入模版
特别主意：需要把各监控项改成被动监控模式，并根据实际情况修改数据更新间隔！！！


监控参数说明：

```
globalLock.activeClients.readers 当前活跃客户端中进行读操作的个数
globalLock.activeClients.writers 当前活跃客户端中进行写操作的个数
globalLock.currentQueue.total 当前的全局锁等待锁等待的个数
globalLock.currentQueue.readers 当前的全局读锁等待个数
globalLock.currentQueue.writers 当前全局写锁等待个数
connections.totalCreated 截止目前为止总共创建的连接数
connections.current 当前连接数
connections.available 可用连接数
backgroundFlushing.flushes 数据库刷新写操作到磁盘的总次数，会逐渐增长
backgroundFlushing.total_msmongod 写数据到磁盘消耗的总时间，单位ms
backgroundFlushing.average_ms 上述两值的比例，表示每次写磁盘的平均时间
backgroundFlushing.last_ms 当前最后一次写磁盘花去的时间，ms，结合上个平均值可观察到mongd总体写性能和当前写性能
mem.bits 操作系统位数
mem.resident 物理内存消耗，单位M
mem.virtual 虚拟内存消耗
mem.mapped 映射内存
extra_info.heap_usage_bytes 堆内存空间占用的字节数，仅linux适用
extra_info.page_faults 数据库访问数据时发现数据不在内存时的页面数量，当数据库性能很差或者数据量极大时，这个值会显著上升
network.bytesIn 数据库接收到的网络传输字节数，可通过该值观察是否到了预计的期望值
network.bytesOut 从数据库发送出去的网络传输字节数
network.numRequestsmongod 接收到的总的请求次数
indexCounters.accesses 索引访问次数，值越大表示你的索引总体而言建得越好，如果值增长很慢，表示系统建的索引有问题
indexCounters.hits 索引命中次数，值越大表示mogond越好地利用了索引
indexCounters.misses 表示mongod试图使用索引时发现其不在内存的次数，越小越好
indexCounters.resets 计数器重置的次数
indexCounters.missRatio 丢失率，即misses除以hits的值
process mongodb 进程，主要有mongod和mongos(分片集群)两种
uptime  mongod 服务启动后到现在已经存活的秒数
version mongodb 版本
opcounters.command    mongod   最近一次启动后的执行command命令的次数
opcounters.insert    mongod       最近一次启动后的insert次数
opcounters.query    mongod     最近一次启动后的query次数
opcounters.update    mongod   最近一次启动后的update次数
opcounters.delete    mongod   最近一次启动后的delete次数
opcounters.getmore    mongod  最近一次启动后的getmore次数,这个值可能会很高，因为子节点会发送getmore命令，作为数据复制操作的一部分
opcountersRepl.insert    mongod 副本集的最近一次启动后的insert次数
opcountersRepl.query    mongod 副本集的最近一次启动后的query次数
opcountersRepl.update    mongod 副本集的最近一次启动后的update次数
opcountersRepl.delete    mongod 副本集的最近一次启动后的delete次数
opcountersRepl.getmore  mongod 副本集的最近一次启动后的getmore次数,这个值可能会很高，因为子节点会发送getmore命令，作为数据复制操作的一部分
```


