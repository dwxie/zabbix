使用zabbix自带模板监控mysql

zabbix自带监控模板监控mysql需要一个用户来获取相关参数的值，需要注意的是给这个用户授权时要注意权限，不能让这个用户有权查看zabbix数据之外的库。

1、授权用户访问 zabbix数据库，用户名可以自己定义

    mysql -uroot -ppassword
    grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
    flush privileges
    quit

2、修改zabbix-agent配置文件： vim userparameter_mysql.conf，并重启zabbix-agent

    UserParameter=mysql.status[*],echo "show global status where Variable_name='$1';" | mysql -S /var/run/mysqld/mysqld.sock -hlocalhost -uzabbix  -N | awk '{print $$2}'
    
    UserParameter=mysql.size[*],bash -c 'echo "select sum($(case "$3" in both|"") echo "data_length+index_length";; data|index) echo "$3_length";; free) echo "data_free";; esac)) from information_schema.tables$([[ "$1" = "all" || ! "$1" ]] || echo " where table_schema=\"$1\"")$([[ "$2" = "all" || ! "$2" ]] || echo "and table_name=\"$2\"");" | mysql -S /var/run/mysqld/mysqld.sock -hlocalhost -uzabbix -N'
    
    UserParameter=mysql.ping,mysqladmin -S /var/run/mysqld/mysqld.sock -hlocalhost -uzabbix | grep -c alive
    UserParameter=mysql.version,mysql -V

3、关联zabbix server自带mysql模版到相应主机


