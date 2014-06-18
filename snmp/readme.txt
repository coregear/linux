#屏蔽snmp系统日志
# /etc/sysconfig/snmpd.options
OPTIONS="-LS3d -Lf /dev/null -p /var/run/snmpd.pid"  
