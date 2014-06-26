#安装LAMP环境，（apche 2.4.6  php 5.5.3）

#apache

tar jxvf apr-1.5.0.tar.bz2 && cd apr-1.5.0
#注释掉configure文件中的某行，解决“/bin/rm: cannot remove `libtoolT’: No such file or directory ”
sed -i '/$RM "$cfgfile"/ s/^/#/' configure
./configure --prefix=/usr/local/apr && make && make install || exit 1
cd ..
#apr-util
tar jxvf apr-util-1.5.3.tar.bz2  &&  apr-util-1.5.3
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/bin/apr-1-config  && make && make install

#pcre
cd ..
echo "Start the installation of pcre..."
tar jxvf pcre-8.34.tar.bz2 && cd pcre-8.34
./configure --prefix=/usr/local/pcre && make && make install 

sleep 2
tar zxvf httpd-2.4.9.tar.gz && cd httpd-2.4.9 && ./configure --prefix=/usr/local/apache2 --sysconfdir=/etc/httpd --with-apr=/usr/local/apr/bin/apr-1-config --with-apr-util=/usr/local/apr-util/bin/apu-1-config  --with-pcre=/usr/local/pcre/ --enable-mods-shared=most  --enable-rewirte --enable-so --enable-ssl=static --with-ssl  && make && make install

#php务必包含snmp、sockets、PDO_MYSQL和json扩展(json默认包含) #sockets和snmp为cacti必需，若无sockets扩展，安装界面无法打开，提示缺少sockets扩展，安装过程中要指定snmp的路径  
#pdo_mysql和json扩展为NPC插件所需要 （nagios plugin for cacti）


yum install net-snmp net-snmp-devel net-snmp-utils
#snmpd.conf可以保持原样，直接启动服务即可

#php编译参数       
./configure --prefix=/usr/local/php5.3  --with-config-file-path=/usr/local/php5.3/etc --with-apxs2=/usr/local/apache2/bin/apxs --with-libxml-dir --with-iconv-dir --with-png-dir --with-jpeg-dir=/usr/local/jpeg --with-zlib --with-gd=/usr/local/gd --with-freetype-dir=/usr/local/freetype --with-mcrypt --with-mhash --enable-gd-native-ttf  --with-curl --with-bz2 --enable-mysqlnd --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-openssl-dir --without-pear --enable-xml --enable-zip --enable-sockets --with-snmp
make
make install

# php.ini的设置
# 1 php一定要允许exec()函数的执行
# 2 date.timezone = Asia/Chongqing

#安装rrdtool
yum install rrdtool

#创建cacti使用的数据库,并添加用户

mysql --user=root --password=123456 <<EOF
CREATE DATABASE cacti;
GRANT ALL PRIVILEGES ON cacti.* TO cactiuser@localhost IDENTIFIED BY 'cactiuser';
FLUSH PRIVILEGES;
EOF

#cacti安装
tar zxvf cacti-0.8.8b.tar.gz -C ${apache_DocumentRoot}
#解压、导入cacti.sql到cacti库,填写mysql连接信息、URL变量，web访问开始安装

#安装过程中主要是指定各程序的路径，php snmp等

#安装完成后的配置主要是Console->Settings->general设置各程序的版本
net-snmp -->5.x
rrdtool -->1.3x
snmp ---> version2

#Devices-->设置单个主机的信息
snmp--> version2

#添加计划任务
*/5 * * * * php poller.php > /dev/null 2&1

#出问题的话多留意apache的日志，会有很多提示


==========================================================



#安装spine,一种更高效的轮询机制，替换cacti自带的[poller type]--- cmd.php
#http://www.cacti.net/downloads/spine/ 下载地址，注意与cacti版本保持一致
tar zxvf cacti-spine-0.8.8b.tar.gz && cd cacti-spine-0.8.8b
./configure --prefix=/usr/local/spine
make && make install

#编辑spine配置文件 /usr/local/spine/etc/spine.conf,填写正确的数据库连接信息

#cacti的Console-->Settings-->Poller,将轮询方式更换为spine

============================================================


# ndoutils,将nagios收集的数据存入mysql,然后由cacti读取并显示出来
tar zxvf ndoutils-1.5.2.tar.gz && cd  ndoutils-1.5.2
./configure --enable-mysql --with-mysql=/usr/local/mysql/

#遇到的错误：
../include/config.h:261:25: error: mysql/mysql.h: No such file or directory
../include/config.h:262:26: error: mysql/errmsg.h: No such file or directory

#解决：
vi ndoutils-1.5.2/include/config.h
将以下两行中的/mysql/去掉,这应该是个拼接，#include代表/usr/local/mysql/include/(./configure中指定的)，再拼接上后边的变成了/usr/local/mysql/include/mysql/mysql.h,所以多出了一层目录，故提示找不到
#include </mysql/mysql.h>
#include </mysql/errmsg.h>

make

cp -v src/{ndomod-3x.o,ndo2db-3x,file2sock,log2ndo}  /usr/local/nagios/bin
#创建ndodb库
mysql --user=root --password=123456 <<EOF
CREATE DATABAS ndodb;
GRANT ALL PRIVILEGES ON ndodb.* TO ndouser@localhost IDENTIFIED BY '123456';
FLUSH PRIVILEGES;
EOF
 
cd ndoutils-1.5.2/db
#生成ndoutils所需要的数据库表等，这些表默认以“nagios_”为前缀
./installdb -u ndouser -p 123456 -h localhost -d ndodb
#installdb是一个perl脚本，执行它需要用到perl的DBI和DBD::mysql模块，如果没有先安装 

#复制、编辑配置文件
cd ndoutils-1.5.2/config
cp ndo2db.cfg-sample  /usr/local/nagios/etc/ndo2db.cfg
cp ndomod.cfg-sample  /usr/local/nagios/etc/ndomod.cfg
chmod 644 /usr/local/nagios/etc/ndo*
chown nagios:nagios /usr/local/nagios/etc/ndo*
chown nagios:nagios /usr/local/nagios/bin/*

vi /usr/local/nagios/etc/nagios.cfg
event_broker_options=-1
broker_module=/usr/local/nagios/bin/ndomod-3x.o config_file=/usr/local/nagios/etc/ndomod.cfg

#编辑ndo2db和ndomod的配置文件
vi /usr/local/nagios/etc/ndo2db.cfg

socket_type=unix
socket_name=/usr/local/nagios/var/ndo.sock

db_servertype=mysql
db_host=localhost
db_port=3306
db_name=ndodb
db_prefix=nagios_
db_user=ndouser
db_pass=123456

vi /usr/local/nagios/etc/ndomod.cfg
output_type=unixsocket
output=/usr/local/nagios/var/ndo.sock

#启动ndo2db
/usr/local/nagios/bin/ndo2db-3x -c /usr/local/nagios/etc/ndo2db.cfg

#查看系统日志确认启动正常

#重启nagios,彻底关闭再启动
service nagios stop
rm -f /usr/local/nagios/var/nagios.lock
service nagios start

#进到web页面查看nagios的日志是否成功加载ndomod模块以及ndo2db是否连接到成功连接到mysql

=============================================================
#安装ntop

#首先安装GeoIP GeoIP-devel，默认的yum源中没有这两个包，添加epel  yum源
wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6-8.noarch.rpm

yum install ntop
#设置ntop管理员的密码
ntop -A

#添加一个普通用户来运行ntop
useradd -M -s /sbin/nologin -r ntop
#启动ntop
ntop -i eth0 -d -L -u ntop
#查看ntop的效果
http://ip:3000

==========================================================

#将ntop和nagios整合进cacti，也就是给cacti安装插件

#整合ntop,安装ntop-v0.2-1.tgz插件
tar zxvf ntop-v0.2-1.tgz -C /data/www/cacti/plugins

#在cacti的console->Settings->Misc中填写ntopd的url,比如http://192.168.126.130:3000
#然后在cacti的console->Plugin Management中安装并开启ntop插件就可以了


==========================================================

#整合nagios,安装npc(nagios-plgin-for-cacti)
tar zxvf npc-2.0.4.tar.gz -C /data/www/cacti/plugins
#在cacti的Console-->Plugin Management中安装npc插件，安装过程中会在cacti库中生成npc_*数据表，结构跟之前安装ndoutils时创建的ndodb库
#里的nagios_*是一样的，有了npc插件以后，原来的ndodb库就没用了，应该修改ndo2db的设置，让它把nagios的数据直接写到cacti库中，npc插件
#会读取ndo2db写入的数据，然后在cacti界面中展现出来

#Console-->Settings-->NPC设置nagios的相关信息
# Remote Commands [选中]
# Nagios Command File Path-->/usr/local/nagios/var/rw/nagios.cmd
# Nagios URL  http://xxxxx/nagios
#



# 修改ndo2db的配置文件
# db_name 由ndodb改为cacti
# db_prefix 由nagios_改为npc_
# 当然，要确保ndo2db使用的用户有权限向cacti的npc_*中写数据


#为cacti库中的npc_*表添加缺失的字段，ndo2db在将nagios收集的数据写入cacti的npc_表写入数据的时候会报缺少long_output字段的错误。
mysql --user=root --password=123456 <<EOF
use cacti;
ALTER TABLE npc_eventhandlers ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_hostchecks ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_hoststatus ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_notifications ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_servicechecks ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_servicestatus ADD long_output TEXT NOT NULL AFTER output;
ALTER TABLE npc_statehistory ADD long_output TEXT NOT NULL  AFTER output;
ALTER TABLE npc_systemcommands ADD long_output TEXT NOT NULL  AFTER output;
EOF



#重启ndo2db和nagios,注意彻底关闭再启动
# /usr/local/nagios/bin/ndo2db-3x -c /usr/local/nagios/etc/ndo2db.cfg
# service nagios start
#查看系统日志确认ndo2db已经把数据写入cacti库中