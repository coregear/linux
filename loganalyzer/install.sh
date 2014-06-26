#假设服务器已正常运行apache及mysql
#安装rsyslog
yum install rsyslog
#安装rsyslog的mysql模块，使之可以将日志写入mysql
yum install rsyslog-mysql

#修改rsyslog的配置文件
vi /etc/rsyslog.conf

#一下两行的注释去掉，让rsyslog运行在UDP514端口，客户端会将自己的日志发送到服务端的UDP514端口
$ModLoad imudp
$UDPServerRun 514

$ModLoad ommysql.so   #新加此行，rsyslog加载mysql模块
*.* :ommysql:localhost,Syslog,rsyslog,123456  #新加此行，rsyslog使用用户rsyslog,将所有日志写入mysql的Syslog库中，123456是用户rsyslog的密码

#创建rsyslog需要的数据库
cd /usr/share/doc/rsyslog-mysql-5.8.10/
mysql -u root -p < createDB.sql  #该操作会创建Syslog库，库中含两张表，其中的SystemEvents正是loganalyzer要读取的表


grant all privileges on Syslog.* to rsyslog@'localhost' identified by '123456';

flush privileges;

#重启rsyslog

service rsyslog restart #正常的话此时SystemEvents表中应该已经被写入数据，因为rsyslog已经开始将日志存储进mysql

#以上操作使得rsyslog将系统日志写入mysql，接下来安装loganalyzer,作用是将日志从mysql读出来，并以web形式展示

#下载loganalyzer

wget http://download.adiscon.com/loganalyzer/loganalyzer-3.6.3.tar.gz

#在apache可以访问到的位置创建目录，用来存放loganalyzer的程序
mkdir /data/www/loganalyzer

tar zxvf loganalyzer-3.6.3.tar.gz
cd loganalyzer-3.6.3

#将安装文件复制到创建的loganalyzer目录

cp -a src/* /data/www/loganalyzer/
cp -a contrib/* /data/www/loganalyzer/

cd /data/www/loganalyzer

sh configure.sh #创建config.php文件并赋予其写入权限

http://ip/loganalyzer  #进入web安装界面

安装完成后执行secure.sh,将config.php权限修改为644。


#显示ip地址，默认loganalyzer只显示日志的来源主机名，不好区分日志到底来自哪台主机，可以让它显示日志的来源IP

#在Syslog库中的SystemEvents表中添加一个字段，用来记录来源IP
ALTER TABLE SystemEvents ADD FromIP VARCHAR(60) DEFAULT NULL AFTER FromHost;

#修改rsyslog.conf

#以下内容的作用是让rsyslog在将日志写入Mysql的时候将来源IP写入到FromIP字段，这样在loganalyzer读取日志的时候才可能取到ip信息
$template insertpl,"insert into SystemEvents (Message, Facility, FromHost, FromIP, Priority, DeviceReportedTime, ReceivedAt, InfoUnitID, SysLogTag) values ('%msg%', %syslogfacility%, '%HOSTNAME%', '%fromhost-ip%', %syslogpriority%, '%timereported:::date-mysql%', '%timegenerated:::date-mysql%', %iut%, '%syslogtag%')",SQL

$ModLoad ommysql.so
*.* :ommysql:localhost,Syslog,rsyslog,123456;insertpl

#重启rsyslog

#管理员身份登录loganalyzer，在Aamin Center中新建Field  View 和DBmapping，然后用新的view来显示，页面上就会有ip信息了

#field定义的变量，view定义哪些变量将显示在页面上，DBmapping定义的field变量取什么值






