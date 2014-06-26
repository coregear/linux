#服务端
cacti导入模版 cacti_data_query_lvs.xml
snmp-lvs.xml上传到cacti_path/resource/net_queries目录下


Host Templates-->Add
#填写一下信息
Name：自定义

Associated Graph Templates： ucd/net-LVS-Connections --> Add
Save

Data Templates --> ucd/net - LVS-Connections

Data Input Method --> Get SNMP Data
OID 

Save

#客户端
安装snmp-lvs-module

rpm -ivh net-snmp-lvs-module-0.0.4-5.el6.x86_64.rpm
#验证是否安装成功
snmptranslate -m LVS-MIB -On -IR lvsServiceEntry

snmpwalk -v 2c 172.16.83.93 -c public .1.3.6.1.4.1.8225.4711.17.1.10


vi /etc/snmp/snmpd.conf ,加入以下行

dlmod lvs /usr/lib64/libnetsnmplvs.so

service snmpd restart
