

# Zabbix之activemq监控插件使用方法
对activemq全局和单个queue的关键指标监控,可自动发现加入的queue并进行监控。

activemq版本需大于5.8.0

activemq需开启控制台，默认是开启的，其端口默认是8161



### 具体步骤：

(1)在zabbix web控制台导入模板文件zbx_activemq.status_templates.xml

(2)在zabbix web控制台添加activemq主机并为其引入刚导入的模板activemq_status

(3)在activemq主机安装zabbix agent

(4)在activemq主机下，将activemq.conf文件放入/etc/zabbix/zabbix_agentd.conf.d/

(5)在activemq主机下，将activemq.py文件放入/etc/zabbix/scripts/,并为其加上可执行权限。

(6)在activemq.py找到如下代码段，修改参数。一般只需修改最后两项即可。

ActivemqHost="127.0.0.1"                   # Activemq instance IP Address
ActivemqConPort="8161"                     # Activemq console port
ActivemqApiPrefix="/api/jolokia/read/"     # Activemq REST API Prefix String
ActivemqBrokerName="localhost"             # Activemq broker name
ActivemqAdminUser="admin"                  # Activemq console administrator
ActivemqAdminPasswd="admin"                # Activemq console administrator password

(7)在activemq主机下，重启zabbix agent



### 监控指标说明

--------------
##### Activemq全局

| 指标                      | 说明               | info   | warning  | average  |
| ----------------------- | ---------------- | ------ | -------- | -------- |
| StorePercentUsage       | 存储空间百分比          |        | >80%     | >90%     |
| MemoryPercentUsage      | 内存空间百分比          |        | >70%     | >80%     |
| TempPercentUsage        | 临时空间百分比          |        | >80%     | >90%     |
| TotalDequeueCount       | 出队消息总数           |        |          |          |
| TotalEnqueueCount       | 入队消息总数           |        |          |          |
| TotalProducerCount      | 总生产者数量           |        |          |          |
| TotalConsumerCount      | 总消费者数量           |        |          |          |
| CurrentConnectionsCount | 目前连接数            |        |          |          |
| AverageMessageSize      | 平均消息尺寸（单位byte字节） |        |          |          |
| 8161 port               | 816端口是否开启        | 一次检测不到 | 2分钟内检测不到 | 5分钟内检测不到 |



##### Activemq单个queue

| 指标            | 说明          | info | warning | average |
| ------------- | ----------- | ---- | ------- | ------- |
| QueueSize     | 队列中等待被处理消息数 |      |         |         |
| EnqueueCount  | 入队消息总数      |      |         |         |
| DequeueCount  | 出队消息总数      |      |         |         |
| ProducerCount | 生产者数量       |      |         |         |
| ConsumerCount | 消费者数量       |      |         |         |

