# ------------------------------
# �汾˵��
# ------------------------------
// ��zookeeperʵ���ؼ�ָ����м��

# ------------------------------
# ���ʹ�÷���
# ------------------------------
(1)��zabbix web����̨����ģ���ļ�zbx_zk.status_templates.xml
(2)��zabbix web����̨���zookeeper������Ϊ������յ����ģ��zookeeper_status
(3)��zk�����£���zookeeper.conf�ļ�����/etc/zabbix/zabbix_agentd.conf.d/
(4)��zk�����£���zookeeper.py�ļ�����/etc/zabbix/scripts/,��Ϊ����Ͽ�ִ��Ȩ��
(6)��zookeeper.py�ҵ����´���Σ��޸Ĳ�����һ��Ĭ�ϼ��ɡ�
zk_host = "127.0.0.1"
zk_client_port = 2181
(7)��zk�����£�����zabbix-agent

# ------------------------------
# zk���ָ��˵��
# ------------------------------
zk_server_state || zookeeper��ɫ���ַ������͡�
zk_num_alive_connections || ��ǰ������
zk_watch_count || ��������
zk_znode_count || �ڵ���
zk_packets_received || �յ������ݰ�
zk_packets_sent | ���͵����ݰ�
zk_approximate_data_size || �ϼ����ݴ�С
zk_open_file_descriptor_count || ���ļ���������
zk_self_check || zookeeper�Լ죬�ַ������͡�

zk_followers || followers��ɫ����Ŀ,��ص�zk��ɫ��leader���д����ݡ�
zk_synced_followers || ��ͬ����followers��ɫ����Ŀ����ص�zk��ɫ��leader���д����ݡ�
zk_pending_syncs || �ȴ�ͬ����followers��ɫ����Ŀ����ص�zk��ɫ��leader���д����ݡ�

--------------