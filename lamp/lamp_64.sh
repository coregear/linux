#!/bin/bash
echo "Renew the sources for yum,please wait..."
sleep 2
cd /etc/yum.repos.d && mv CentOS-Base.repo CentOS-Base.repo.bak && wget http://mirrors.163.com/.help/CentOS-Base-163.repo
echo "First,Update the system,Please wait..."
yum -y update
echo "Now,install dependent libraries.Please waiting..."
sleep 2
yum -y install gcc gcc-c++ libtool ncurses ncurses-devel openssl openssl-devel curl curl-devel readline readline-devel bzip2 bzip2-devel fontconfig-devel sqlite sqlite-devel zlib zlib-devel
#ncurses  openssl为编译mysql5必须
sourcedir="/usr/local/src/lnmp/"

[ "$PWD" != "$sourcedir" ] && cd $sourcedir

echo "Start the installation of libxml2..."
sleep 2
tar zxvf libxml2-2.7.6.tar.gz && cd libxml2-2.7.6
#注释掉configure文件中的某行，解决“/bin/rm: cannot remove `libtoolT’: No such file or directory ”
sed -i '/$RM "$cfgfile"/ s/^/#/' configure
./configure --prefix=/usr && make && make install || exit 1

#下边的操作将解决PHP等安装过程中提示libxml2.so.2版本有误、libxml找不到及找不到libpng14.so.14的问题。
if [ -f /usr/lib/libxml2.so ];then
rm -f /usr/lib/libxml2.so && ln -s /usr/lib/libxml2.so.2.7.6 /usr/lib/libxml2.so
fi
if [ -f /usr/lib/libxml2.so.2 ];then
rm -f /usr/lib/libxml2.so.2 && ln -s /usr/lib/libxml2.so.2.7.6 /usr/lib/libxml2.so.2
fi
if [ -f /usr/lib/libxml2.so.2.6.26 ];then
rm -f /usr/lib/libxml2.so.2.6.26
fi
if [ -f /usr/lib64/libxml2.so ];then
rm -f /usr/lib64/libxml2.so
fi
if [ -f /usr/lib64/libxml2.so.2 ];then
rm -f /usr/lib64/libxml2.so.2
fi
cp /usr/lib/libxml2.so.2.7.6 /usr/lib64 && ln -s /usr/lib64/libxml2.so.2.7.6 /usr/lib64/libxml2.so && ln -s /usr/lib64/libxml2.so.2.7.6 /usr/lib64/libxml2.so.2

echo "/usr/lib64" >> /etc/ld.so.conf
ldconfig

echo 'OK,libxml2-2.7.6 has  been successfully installed!'
##########################
cd ..
echo "Start the installation of libiconv..."
sleep 2
tar zxvf libiconv-1.14.tar.gz && cd libiconv-1.14 && ./configure --prefix=/usr && make && make install || exit 1
echo 'OK,libiconv-1.14 has  been successfully installed!'

cd ..
echo "Start the installation of libxslt..."
sleep 2
tar zxvf libxslt-1.1.28.tar.gz && cd libxslt-1.1.28 || exit 1
#注释掉configure文件中的某行，解决“/bin/rm: cannot remove `libtoolT’: No such file or directory ”
sed -i '/$RM "$cfgfile"/ s/^/#/' configure
./configure --prefix=/usr && make && make install || exit 1
echo 'OK,libxslt-1.1.26 has  been successfully installed!'

cd ..
echo "Start the installation of libmcrypt..."
sleep 2
tar zxvf libmcrypt-2.5.8.tar.gz && cd libmcrypt-2.5.8 && ./configure --prefix=/usr && make && make install || exit 1
echo 'OK,libmcrypt-2.5.8 has  been successfully installed!'

echo "Start the installation of libltdl..."
sleep 2
cd libltdl && ./configure --prefix=/usr/ --enable-ltdl-install && make && make install || exit 1
echo 'OK,libltdl has  been successfully installed!'

cd ../../
echo "Start the installation of mhash..."
sleep 2
tar jxvf mhash-0.9.9.9.tar.bz2 && cd mhash-0.9.9.9 && ./configure && make && make install || exit 1
echo 'OK,mhash-0.9.9.9 has  been successfully installed!'

echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig

cd ..
echo "Start the installation of mcrypt..."
sleep 2
tar zxvf mcrypt-2.6.8.tar.gz && cd mcrypt-2.6.8  && ./configure && make && make install || exit 1
echo 'OK,mcrypt-2.6.8 has  been successfully installed!'

cd ..
echo "Start the installation of libevent..."
sleep 2
tar zxvf libevent-2.0.21-stable.tar.gz && cd libevent-2.0.19-stable && ./configure --prefix=/usr && make && make install || exit 1
echo 'OK,libevent-2.0.21 has  been successfully installed!'

cd ..
echo "Start the installation of libpng..."
sleep 2
tar zxvf libpng-1.6.2.tar.gz && cd libpng-1.6.2 && ./configure --prefix=/usr && make && make install || exit 1
#ln -s /usr/lib/libpng15.so.15.12.0  /usr/lib64/libpng15.so.15
echo 'OK,libpng-1.6.2 has  been successfully installed!'

cd ..
echo "Start the installation of jpeg..."
sleep 2
tar zxvf jpegsrc.v9.tar.gz && cd jpeg-9 && ./configure --prefix=/usr/local/jpeg --enable-shared --enable-static && make && make install || exit 1
echo 'OK,jpeg-v9 has  been successfully installed!'

cd ..
echo "Start the installation of freetype..."
sleep 2
tar zxvf freetype-2.4.12.tar.gz && cd freetype-2.4.12 && ./configure --prefix=/usr/local/freetype && make && make install || exit 1
echo 'OK,freetype-2.4.12 has  been successfully installed!'

cd ..
echo "Start the installation of gd2..."
sleep 2
tar zxvf gd-2.0.35.tar.gz && cd gd/2.0.35 && ./configure --prefix=/usr/local/gd --with-zlib --with-png --with-jpeg=/usr/local/jpeg --with-freetype=/usr/local/freetype && make && make install || exit 1
echo 'OK,gd-2.0.35 has  been successfully installed!'

cd ../../
echo "Start the installation of cmake..."
sleep 2
tar zxvf cmake-2.8.11.2.tar.gz && cd cmake-2.8.11.2 && ./configure --prefix=/usr && make && make install || exit 1
echo 'OK,cmake-2.8.11has  been successfully installed!'

cd ..
echo "Start the installation of mysql..."
sleep 2

tar zxvf mysql-5.6.12.tar.gz && cd mysql-5.6.12 && cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql/ -DMYSQL_DATADIR=/data/mysql/data -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1 -DMYSQL_TCP_PORT=3306 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_PARTITION_STORAGE_ENGINE=1 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DWITH_DEBUG=0  -DWITH_SSL=yes -DSYSCONFDIR=/data/mysql -DMYSQL_TCP_PORT=3306 && make && make install || exit 1

echo 'OK,MySQL-5.6.12 has  been successfully installed!'
sleep 2
echo "Prepare for start MySQL,Please wait...."
sleep 2
useradd -s /sbin/nologin www
useradd -s /sbin/nologin mysql
mkdir -p /data/mysql/{data,binlog,relaylog}
chown -R mysql:mysql /data/mysql
touch /data/mysql/my.cnf
echo -ne "[client]\ndefault-character-set=gbk\nport = 3306\nsocket = /tmp/mysql.sock\n[mysqld]\ncharacter-set-server = gbk\ncollation-server = gbk_chinese_ci\n#replicate-ignore-db = mysql\n#replicate-ignore-db = test\n#replicate-ignore-db = information_schema\nuser = mysql\nport = 3306\nsocket  = /tmp/mysql.sock\nbasedir = /usr/local/mysql\ndatadir = /data/mysql/data\nexplicit_defaults_for_timestamp=true\nlog-error = /data/mysql/mysql_error.log\npid-file = /data/mysql/mysql.pid\nopen_files_limit    = 10240\nback_log = 600\nmax_connections = 5000\nmax_connect_errors = 6000\ntable_cache = 614\nexternal-locking = FALSE\nmax_allowed_packet = 32M\nsort_buffer_size = 1M\njoin_buffer_size = 1M\nthread_cache_size = 300\nthread_concurrency = 8\nquery_cache_size = 512M\nquery_cache_limit = 2M\nquery_cache_min_res_unit = 2k\ndefault-storage-engine = MyISAM\nthread_stack = 192K\ntransaction_isolation = READ-COMMITTED\ntmp_table_size = 246M\nmax_heap_table_size = 246M\nlong_query_time = 3\nlog-slave-updates\nlog-bin = /data/mysql/binlog/binlog\nbinlog_cache_size = 4M\nbinlog_format = MIXED\nmax_binlog_cache_size = 8M\nmax_binlog_size = 1G\nexpire-logs-days = 30\nrelay-log-index = /data/mysql/relaylog/relaylog\nrelay-log-info-file = /data/mysql/relaylog/relaylog\nrelay-log = /data/mysql/relaylog/relaylog\nexpire_logs_days = 30\nkey_buffer_size = 256M\nread_buffer_size = 1M\nread_rnd_buffer_size = 16M\nbulk_insert_buffer_size = 64M\nmyisam_sort_buffer_size = 128M\nmyisam_max_sort_file_size = 10G\nmyisam_repair_threads = 1\n;myisam_recover\n\ninteractive_timeout = 120\nwait_timeout = 120\n\nskip-name-resolve\nslave-skip-errors = 1032,1062,126,1114,1146,1048,1396\n\nserver-id = 1\n\n;innodb_additional_mem_pool_size = 16M\n;innodb_buffer_pool_size = 512M\n;innodb_data_file_path = ibdata1:256M:autoextend\n;innodb_file_io_threads = 4\n;innodb_thread_concurrency = 8\n;innodb_flush_log_at_trx_commit = 2\n;innodb_log_buffer_size = 16M\n;innodb_log_file_size = 128M\n;innodb_log_files_in_group = 3\n;innodb_max_dirty_pages_pct = 90\n;innodb_lock_wait_timeout = 120\n;innodb_file_per_table = 0\n\nslow_query_log\nslow_query_log_file = /data/mysql/slow.log\nlong_query_time = 1\nlog-queries-not-using-indexes\n\n[mysqldump]\nquick\nmax_allowed_packet = 32M\n" >> /data/mysql/my.cnf
ln -s /data/mysql/my.cnf /etc/my.cnf
cp /usr/local/mysql/bin/mysql* /usr/bin/ && cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld && chmod +x /etc/init.d/mysqld || exit 1
/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql
mysqld_safe --user=mysql &
killall mysqld
service mysqld start

#Apache
cd ..
echo "Start the installation of Apache..."
sleep 2
#apr

tar jxvf apr-1.4.8.tar.bz2 && cd apr-1.4.8
#注释掉configure文件中的某行，解决“/bin/rm: cannot remove `libtoolT’: No such file or directory ”
sed -i '/$RM "$cfgfile"/ s/^/#/' configure
./configure --prefix=/usr/local/apr && make && make install || exit 1
cd ..
#apr-util
tar jxvf apr-util-1.5.2.tar.bz2  &&  apr-util-1.5.2
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/bin/apr-1-config  && make && make install || exit 1
#pcre
cd ..
echo "Start the installation of pcre..."
tar jxvf pcre-8.33.tar.bz2 && cd pcre-8.33
./configure --prefix=/usr/local/pcre && make && make install || exit 1
echo 'OK,pcre-8.33 has  been successfully installed!'
cd ..

sleep 2
tar zxvf httpd-2.4.6.tar.gz && cd httpd-2.4.6 && ./configure --prefix=/usr/local/apache2 --sysconfdir=/etc/httpd --with-apr=/usr/local/apr/bin/apr-1-config --with-apr-util=/usr/local/apr-util/bin/apu-1-config  --with-pcre=/usr/local/pcre/ --enable-mods-shared=most  --enable-rewirte --enable-so --enable-ssl=static --with-ssl  --enable-proxy=shared --enable-proxy-balancer=shared --enable-proxy-http=shared  --enable-cache --enable-disk-cache --enable-mem-cache --enable-file-cache  && make && make install || exit 1
if [ ! -d /data/logs ];then
mkdir -p /data/logs/{error,access} #apache日志存放目录
fi
echo "OK,apache-2.4.6 has  been successfully installed!"
sleep 2
#根据PHP版本对该脚本做适当修改
#PHP-5.3.27
cd ..
echo "Start the installation of php..."
sleep 2

tar zxvf php-5.3.27.tar.gz && cd php-5.3.27 &&  ./configure --prefix=/usr/local/php5.5  --with-config-file-path=/usr/local/php5.5/etc --with-apxs2=/usr/local/apache2/bin/apxs --with-libxml-dir --with-iconv-dir --with-png-dir --with-jpeg-dir=/usr/local/jpeg --with-zlib --with-gd=/usr/local/gd --with-freetype-dir=/usr/local/freetype --with-mcrypt --with-mhash --enable-gd-native-ttf  --with-readline --with-curl --with-bz2 --enable-mysqlnd --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-openssl-dir --without-pear  --enable-mbstring --enable-soap --enable-xml --enable-ftp  --enable-zip --enable-bcmath --enable-sockets --enable-opcache && make && make install || exit 1
if [ ! -d /usr/local/php/etc ];then
mkdir /usr/local/php/etc
fi
cp ../php.ini /usr/local/php/etc/ && mkdir /usr/local/php/ext
mkdir -p /data/logs/php #日志存放目录
echo  'OK,PHP-5.3.27 has  been successfully installed!'
sleep 2

cd .. 
echo "Start install memcache extension..."
#如果php版本为5.2，则memcache使用2.2.6版本，否则会因版本问题导致php无法加载memcach模块。
sleep 2
tar zxvf memcache-3.0.6.tgz && cd memcache-3.0.6 && /usr/local/php/bin/phpize && ./configure --enable-memcache --with-php-config=/usr/local/php/bin/php-config && make && make install || exit 1
cp /usr/local/php/lib/php/extensions/no-debug-non-zts-20090626/memcache.so /usr/local/php/ext/
echo  "OK,Memcache-3.0.6 installed successfully!"
sleep 2

#cd ..
#echo "Start install ImageMagick..."
#sleep 2
#tar zxvf ImageMagick-6.6.9-10.tar.gz && cd ImageMagick-6.6.9-10 && ./configure --prefix=/usr/local/imagemagick && make && make install || exit 1
#echo "/usr/local/imagemagick/lib" >> /etc/ld.so.conf && ldconfig
#echo "OK,ImageMagick-6.6.9-10 has been installed successfully!"
#sleep 2

#cd ..
#echo "Start install imagick for php ..."
#tar zxvf imagick-3.0.1.tgz && cd imagick-3.0.1 && /usr/local/php/bin/phpize && ./configure --with-imagick=/usr/local/imagemagick --with-php-config=/usr/local/php/bin/php-config && make && make install || exit 1
#cp /usr/local/php/lib/php/extensions/no-debug-non-zts-20060613/imagick.so  /usr/local/php/ext/
#echo "OK,imagick-3.0.1 for php has been installed successfully!"
#sleep 2

cd ..
echo "Start install PDO_MYSQL ..."
tar zxvf PDO_MYSQL-1.0.2.tgz && cd PDO_MYSQL-1.0.2 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config --with-pdo-mysql=/usr/local/mysql && make && make install || exit 1
cp modules/pdo_mysql.so /usr/local/php/ext/
echo "OK,PDO_MYSQL-1.0.2 has been installed successfully!"
sleep 2

cd ..
echo "Start install APC ..."
tar zxvf APC-3.1.9.tgz && cd APC-3.1.9 
/usr/local/php/bin/phpize
./configure --enable-apc --enable-apc-mmap --with-php-config=/usr/local/php/bin/php-config && make && make install
cp /usr/local/php/lib/php/extensions/no-debug-non-zts-20090626/apc.so /usr/local/php/ext/
#echo -ne "[APC]\nextension = \"apc.so\"\napc.enabled = 1\napc.cache_by_default = on\napc.shm_size = 32M\napc.ttl = 600\napc.user_ttl = 600\napc.write_lock = on" >> /usr/local/php/etc/php.ini
echo -ne "APC-3.1.9 has been installed successfully!"
cd ..
sleep 2

#httpd auto runing
cp /usr/local/apache2/bin/apachectl /etc/init.d/httpd
sed -i '2a # chkconfig: 2345 65 37\
# description: apache service manager.' /etc/init.d/httpd
chkconfig --level 3 httpd on

#http_conf
mv /etc/httpd/httpd.conf /etc/httpd/httpd.conf.default
mv /etc/httpd/extra/httpd-default.conf /etc/httpd/extra/httpd-default.conf.default
mv /etc/httpd/extra/httpd-vhosts.conf /etc/httpd/extra/httpd-vhosts.conf.default
mv /etc/httpd/extra/httpd-mpm.conf /etc/httpd/extra/httpd-mpm.conf.default
cp http-conf/httpd.conf /etc/httpd/
cp http-conf/extra/* /etc/httpd/extra/ 

#apache_cutlog
tar zxvf cronolog-1.6.2.tar.gz && cd cronolog-1.6.2 && ./configure && make && make install || exit 1

cd ..
#ulimit
sed -i '$i *                -       nofile          65535\
*                soft    core            0\
*                hard    core            0' /etc/security/limits.conf

#sysctl.conf
cat sysctl.conf >> /etc/sysctl.conf && sysctl -p

#history保留操作时间
sed -i '/HISTSIZE/a HISTTIMEFORMAT="%Y%m%d-%H%M%S:"'  /etc/profile
sed -i '/export/ s/$/ HISTTIMEFORMAT/' /etc/profile

#su/sudo
#仅wheel组成员可以使用su
sed -i '/required/ s/^#//' /etc/pam.d/su
echo "SU_WHEEL_ONLY  yes" >> /etc/login.defs

#sudo
#Cmnd_Alias MANAGER = /sbin/route, /sbin/ifconfig, /bin/ping, /sbin/iptables, /sbin/service, /sbin/chkconfig, /bin/chmod, /bin/chown, /bin/chgrp
#User_Alias ADMINS = 

#root    ALL=(ALL)     ALL
#ADMINS  ALL=(ALL)     MANAGER

#document_root
if [ ! -d /data/www ];then
mkdir -p /data/www
fi
chown www:www /data/www && touch /data/www/index.php && echo -ne '<?php\nphpinfo();\n?>' > /data/www/index.php
sleep 2

echo -ne "OK,That is all,Thanks for using,Bye!\n"
#10秒之后重启
for i in $(seq 10| tac)
do
	echo -ne "\aThe system will reboot after $i seconds...\r"
	sleep 1
done
echo
shutdown -r now