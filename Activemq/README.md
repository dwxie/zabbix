

# Zabbix֮activemq��ز��ʹ�÷���
��activemqȫ�ֺ͵���queue�Ĺؼ�ָ����,���Զ����ּ����queue�����м�ء�

activemq�汾�����5.8.0

activemq�迪������̨��Ĭ���ǿ����ģ���˿�Ĭ����8161



### ���岽�裺

(1)��zabbix web����̨����ģ���ļ�zbx_activemq.status_templates.xml

(2)��zabbix web����̨���activemq������Ϊ������յ����ģ��activemq_status

(3)��activemq������װzabbix agent

(4)��activemq�����£���activemq.conf�ļ�����/etc/zabbix/zabbix_agentd.conf.d/

(5)��activemq�����£���activemq.py�ļ�����/etc/zabbix/scripts/,��Ϊ����Ͽ�ִ��Ȩ�ޡ�

(6)��activemq.py�ҵ����´���Σ��޸Ĳ�����һ��ֻ���޸��������ɡ�

ActivemqHost="127.0.0.1"                   # Activemq instance IP Address
ActivemqConPort="8161"                     # Activemq console port
ActivemqApiPrefix="/api/jolokia/read/"     # Activemq REST API Prefix String
ActivemqBrokerName="localhost"             # Activemq broker name
ActivemqAdminUser="admin"                  # Activemq console administrator
ActivemqAdminPasswd="admin"                # Activemq console administrator password

(7)��activemq�����£�����zabbix agent



### ���ָ��˵��

--------------
##### Activemqȫ��

| ָ��                      | ˵��               | info   | warning  | average  |
| ----------------------- | ---------------- | ------ | -------- | -------- |
| StorePercentUsage       | �洢�ռ�ٷֱ�          |        | >80%     | >90%     |
| MemoryPercentUsage      | �ڴ�ռ�ٷֱ�          |        | >70%     | >80%     |
| TempPercentUsage        | ��ʱ�ռ�ٷֱ�          |        | >80%     | >90%     |
| TotalDequeueCount       | ������Ϣ����           |        |          |          |
| TotalEnqueueCount       | �����Ϣ����           |        |          |          |
| TotalProducerCount      | ������������           |        |          |          |
| TotalConsumerCount      | ������������           |        |          |          |
| CurrentConnectionsCount | Ŀǰ������            |        |          |          |
| AverageMessageSize      | ƽ����Ϣ�ߴ磨��λbyte�ֽڣ� |        |          |          |
| 8161 port               | 816�˿��Ƿ���        | һ�μ�ⲻ�� | 2�����ڼ�ⲻ�� | 5�����ڼ�ⲻ�� |



##### Activemq����queue

| ָ��            | ˵��          | info | warning | average |
| ------------- | ----------- | ---- | ------- | ------- |
| QueueSize     | �����еȴ���������Ϣ�� |      |         |         |
| EnqueueCount  | �����Ϣ����      |      |         |         |
| DequeueCount  | ������Ϣ����      |      |         |         |
| ProducerCount | ����������       |      |         |         |
| ConsumerCount | ����������       |      |         |         |

