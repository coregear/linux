
#测试环境 CentOS-6.4，最小化安装

=========================================================================

1  安装apache mysql

==========================================================================
2  安装cyrus-sasl

yum install -y cyrus-sasl  cyrus-sasl-devel

vi /usr/lib/sasl2/smtpd.conf

pwcheck_method: saslauthd #使用saslauthd来验证，即明文验证
mech_list: PLAIN LOGIN

#启动saslauthd
/usr/sbin/saslauthd -a shadow

3  安装postfix

echo "/usr/local/mysql/lib" >> /etc/ld.so.conf && ldconfig #将mysql的Lib目录加入到动态库缓存路径，不然后边会提示找不到mysql的client函数库
yum install db4-devel #否则在执行make makefiles的时候会提示找不到db.h
tar zxvf postfix-2.10.1.tar.gz && cd postfix-2.10.1

make makefiles CCARGS='-DUSE_SASL_AUTH -DUSE_CYRUS_SASL -DHAS_SSL -DHAS_MYSQL  -I/usr/local/mysql/include -I/usr/include/sasl/' AUXLIBS='-L/usr/local/mysql/lib -L/usr/lib/sasl2 -lsasl2 -lcrypto -lssl -lmysqlclient -lz -lm '

make 

make install

newaliases  #生成别名二进制文件，这个步骤如果忽略，会造成postfix效率极低

4 初步配置Postfix

myhostname = mail.test.com    #指定运行postfix邮件系统的主机名 
myorigin = test.com     #当发件人的信息不详细时，使用这个默认域 
mydomain = test.com     #指定域名，默认情况下postfix将myhostname的第一部分删除而作为mydomain的值 
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain    #指定发往哪里的邮件postfix服务器负责接收 
mynetworks = 192.168.0.0/24, 127.0.0.0/8  #指定postfix为哪些网段的用户进行邮件中继 
inet_interfaces = all

smtpd_sasl_auth_enable = yes  #postfix开启sasl验证
broken_sasl_auth_clients = yes  #主要为了兼容一些老掉牙的MUA
#启动


/usr/sbin/postfix  start #postfix会检查相关目录的权限设置，若提示某些目录的权限不对，按照提示做修改即可

#到此，postfix已经具备了初步的sasl验证功能，当然，还只能验证系统账户。

#这里遇到的一个比较典型的问题是，系统中有一套cyrus-sasl,我又编译安装了一套，结果启动的saslauthd是自己装的那个，Postfix关联的却是系统默认的，所以一直提示找不到saslauthd，因为他们运行的目录不同。排查的时候用到了ldd，用来查看postfix到底使用了哪个sasl函数库
postfix reload #重新加载配置文件







5 配置postfix开启基于cyrus-sasl的认证
postconf -a #输出内容如下，则代表postfix支持cyrus风格的认证
cyrus
dovecot

#编辑postfix主配置文件，添加一下内容

smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject_invalid_hostname,reject_non_fqdn_hostname,reject_unknown_sender_domain,reject_non_fqdn_sender,reject_non_fqdn_recipient,reject_unknown_recipient_domain,reject_unauth_pipelining,reject_unauth_destination 

smtpd_sasl_local_domain = $myhostname 
smtpd_sasl_security_options = noanonymous 
smtpd_banner = Welcome to our $myhostname ESMTP,Warning: Version not Available!

postfix reload  #重新加载配置文件


6 安装 Courier authentication library 
  安装Courier authentication library是让postfix能够和mysql数据库连接，将用户的帐号和密码放在数据库中，以便能够提供用户认证
tar jxvf courier-authlib-0.65.0.tar.bz2 && cd courier-authlib-0.65.0

./configure --prefix=/usr/local/courier-authlib --without-stdheaderdir --with-authmysql --with-mysql-lib=/usr/local/mysql/lib/ --with-mysql-includes=/usr/local/mysql/include/ --with-ltdl-lib=/usr/lib --with-ltdl-include=/usr/include/
#configure过程中提示缺少expect，将无法在webmail中修改密码,yum 安装
 yum install expect
 
make && make install

7 安装devecot

mkdir /data/mailbox

chown -R postfix:postfix /data/mailbox

useradd -M -s /bin/false devecot

tar zxvf dovecot-2.2.4.tar.gz && cd dovecot-2.2.4

./configure --prefix=/usr/local/dovecot --with-sql --with-sql-drivers --with-mysql

#生成配置文件

make && make install



