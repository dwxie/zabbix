# ------------------------------
# 版本说明
# ------------------------------
// 对zookeeper实例关键指标进行监控

# ------------------------------
# 插件使用方法
# ------------------------------
(1)在zabbix web控制台导入模板文件zbx_zk.status_templates.xml
(2)在zabbix web控制台添加zookeeper主机并为其引入刚导入的模板zookeeper_status
(3)在zk主机下，将zookeeper.conf文件放入/etc/zabbix/zabbix_agentd.conf.d/
(4)在zk主机下，将zookeeper.py文件放入/etc/zabbix/scripts/,并为其加上可执行权限
(6)在zookeeper.py找到如下代码段，修改参数。一般默认即可。
zk_host = "127.0.0.1"
zk_client_port = 2181
(7)在zk主机下，重启zabbix-agent

# ------------------------------
# zk监控指标说明
# ------------------------------
zk_server_state || zookeeper角色，字符串类型。
zk_num_alive_connections || 当前连接数
zk_watch_count || 监听者数
zk_znode_count || 节点数
zk_packets_received || 收到的数据包
zk_packets_sent | 发送的数据包
zk_approximate_data_size || 合计数据大小
zk_open_file_descriptor_count || 打开文件描述符数
zk_self_check || zookeeper自检，字符串类型。

zk_followers || followers角色的数目,监控的zk角色是leader才有此数据。
zk_synced_followers || 已同步的followers角色的数目，监控的zk角色是leader才有此数据。
zk_pending_syncs || 等待同步的followers角色的数目，监控的zk角色是leader才有此数据。

--------------
