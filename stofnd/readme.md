# codispatcher & codproducer 监控自动发现

#### 1、功能说明：

通过自动发现规则对codispatcher & codproducer 进程及端口进行监控，并自动生成相应进程名称和端口的监控项。其中进程使用stofnd_process.py 脚本，端口分别使用codispatcher_port.py、codproducer_port.py。

#### 2、使用方法：

a、把3个python脚本放到/opt/sa_tools/scripts/py/目录下；

b、把stofnd.conf 配置文件放到/usr/local/services/zabbix/etc/zabbix_agentd.conf.d/目录下；

c、重启zabbix-agent之后再关联 codispatcher_port_lld、codproducer_port_lld、stonfnd_process_lld 3个模板到主机。

#### 3、注意事项：

这3个脚本都可以手动执行，并能获取端口或进程的值（json格式）；配置文件和脚本都验证无误后再关联模板。