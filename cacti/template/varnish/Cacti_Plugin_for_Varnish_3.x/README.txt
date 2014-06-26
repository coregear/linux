How to install
==============

1 - Import cacti_host_template_varnish.xml to Cacti (tested with 0.8.8a)
2 - Copy getVarnishStats.sh to "scripts"
3 - Configure snmpd.conf into the varnish server
	3.1 - Add this line to snmpd.conf
			extend varnishstats "/etc/snmp/varnish_stats.sh"
	3.2 - Copy varnish_stats.sh to "/etc/snmp"

###############################################################################
IMPORTANT: You need to recompile spine with "./configure --with-results-buffer=2048"
###############################################################################

NOTE: Changing "getVarnishStats.sh" you can change your poll method.

如何安装
==============

1 - 导入 cacti_host_template_varnish.xml 模板到 Cacti (tested with 0.8.8a)
2 - 复制 getVarnishStats.sh 到 Cacti的 "scripts" 目录下
3 - 配置 snmpd.conf 来支持Varnish
	3.1 - 向 snmpd.conf 尾行添加一行内容
			extend varnishstats "/etc/snmp/varnish_stats.sh"
	3.2 - 复制 varnish_stats.sh 到 "/etc/snmp"

###############################################################################
注意: 因varnish返回snmp数据长度过大，需要重新编译 spine 并加上缓冲大小参数
例如： "./configure --with-results-buffer=2048"
###############################################################################

说明: 更改 "getVarnishStats.sh" 中的参数，来选择SNMP版本,SNMP V3需要在脚本中指定用户名和密码