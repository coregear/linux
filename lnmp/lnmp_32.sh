#!/bin/bash
echo "Renew the sources for yum,please wait..."
sleep 2
#cd /etc/yum.repos.d && mv CentOS-Base.repo CentOS-Base.repo.bak && wget http://mirrors.163.com/.help/CentOS-Base-163.repo
#echo "First,Update the system,Please wait..."
#yum -y update
echo "Now,install dependent libraries.Please waiting..."
sleep 2
yum -y install gcc gcc-c++ libtool ncurses ncurses-devel openssl openssl-devel curl curl-devel readline readline-devel bzip2 bzip2-devel fontconfig-devel sqlite sqlite-devel zlib zlib-devel
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

#echo 'OK,libxml2-2.7.6 has  been successfully installed!'
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

#不保留mysql操作记录
if [ -f /root/.mysql_history ];then
rm -f /root/.mysql_history && ln -s /dev/null /root/.mysql_history
fi

#设置MySQL root密码，清除空密码账户
mysql -u root mysql < ../mysql.user.sql
#mysqld自启动
chkconfig --level 3 mysqld on

#PHP-5.3.16
cd ..
echo "Start the installation of php..."
sleep 2

#Start installation
tar zxvf php-5.3.16.tar.gz && cd php-5.3.16 && ./configure --prefix=/usr/local/php  --with-config-file-path=/usr/local/php/etc --with-libxml-dir --with-iconv-dir --with-png-dir --with-jpeg-dir=/usr/local/jpeg --with-zlib --with-gd=/usr/local/gd --with-freetype-dir=/usr/local/freetype --with-mcrypt --with-mhash --enable-gd-native-ttf  --with-readline --with-curl --with-bz2 --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-openssl-dir --without-pear --enable-fpm --enable-mbstring --enable-soap --enable-xml --enable-pdo --enable-ftp  --enable-zip --enable-bcmath --enable-sockets && make && make install || exit 1
cp ../{php.ini,php-fpm.conf} /usr/local/php/etc/ && mkdir /usr/local/php/ext
if [ ! -d /data/logs/php ];then
mkdir -p /data/logs/php #日志存放目录
fi
echo  'OK,PHP-5.3.16 has  been successfully installed!'

#PHP-5.2.17
#cd ..
#tar zxvf php-5.2.17.tar.gz && cd php-5.2.17
#patch -p1 < ../php-5.2.17-fpm-0.5.14.diff && ./buildconf --force || exit 1 
#rm -f /usr/lib/libxml2.so.2.6.26 && cp /usr/lib/libxml2.so.2.7.4 /usr/lib64 && rm -f /usr/lib64/{libxml2.so,libxml2.so.2} && ln -s /usr/lib64/libxml2.so.2.7.4 /usr/lib64/libxml2.so && ln -s /usr/lib64/libxml2.so.2.7.4 /usr/lib64/libxml2.so.2 && ln -s /usr/lib/libpng14.so.14.4.0 /usr/lib64/libpng14.so.14|| exit 1
#./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-libxml-dir  --with-iconv-dir --with-png-dir --with-jpeg-dir=/usr/local/jpeg --with-zlib --with-gd=/usr/local/gd --with-freetype-dir=/usr/local/freetype --with-mcrypt --with-mhash --enable-gd-native-ttf --with-readline --with-curl --with-bz2 --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-openssl-dir --enable-fpm --enable-fastcgi --enable-mbstring --enable-soap --enable-xml --enable-pdo --enable-ftp --enable-safe-mode --enable-zip  --enable-bcmath  --enable-sockets && make && make install || exit 1
#cp php.ini-dist /usr/local/php/etc && cp /usr/local/php/sbin/php-fpm /etc/init.d/ && chmod +x /etc/init.d/php-fpm && mkdir /usr/local/php/ext
#echo  'OK,PHP-5.2.17 has  been successfully installed!'
#sleep 2

cd ..
echo "Start the installation of nginx..."
sleep 2

#下载ngx_cache_purge模块
#wget http://labs.frickle.com/files/ngx_cache_purge-1.5.tar.gz && tar zxvf ngx_cache_purge-1.5.tar.gz
#tar zxvf pcre-8.30.tar.gz && mv pcre-8.30  /usr/local/ && tar zxvf openssl-1.0.1c.tar.gz && mv openssl-1.0.1c /usr/local/ && tar zxvf nginx-1.2.3.tar.gz && cd nginx-1.2.3 && ./configure --prefix=/usr/local/nginx --add-module=../ngx_cache_purge-1.5 --with-pcre=/usr/local/pcre-8.30 --with-openssl=/usr/local/openssl-1.0.1c --with-http_sub_module --with-http_ssl_module --with-http_stub_status_module && make && make install || exit 1

tar zxvf pcre-8.30.tar.gz && mv pcre-8.30  /usr/local/ && tar zxvf openssl-1.0.1c.tar.gz && mv openssl-1.0.1c /usr/local/ && tar zxvf nginx-1.2.3.tar.gz && cd nginx-1.2.3 && ./configure --prefix=/usr/local/nginx  --with-pcre=/usr/local/pcre-8.30 --with-openssl=/usr/local/openssl-1.0.1c --with-http_sub_module --with-http_ssl_module --with-http_stub_status_module && make && make install || exit 1
cat ../nginx.conf > /usr/local/nginx/conf/nginx.conf
echo 'OK,nginx-1.2.3 has  been successfully installed!'

if [ ! -d /data/www ];then
mkdir -p /data/www
fi 
chown www:www /data/www && touch /data/www/index.php && echo -ne '<?php\nphpinfo();\n?>' > /data/www/index.php

cd ..
echo "Start install re2c..."
sleep 2
tar zxvf re2c-0.13.5.tar.gz && cd re2c-0.13.5 && ./configure && make && make install || exit 1
echo "OK,re2c-0.13.5 has  been successfully installed!"

#cd ..
#echo "Start install eaccelerator..."
#sleep 2
#tar jxvf eaccelerator-0.9.6.1.tar.bz2 && cd eaccelerator-0.9.6.1
#/usr/local/php/bin/phpize && ./configure --enable-eaccelerator=shared --with-php-config=/usr/local/php/bin/php-config && make && make install || exit 1
#cp /usr/local/php/lib/php/extensions/no-debug-non-zts-20060613/eaccelerator.so  /usr/local/php/ext/ && mkdir /data/eacache
#echo -ne "[eaccelerator]\nextension=\"/usr/local/php/ext/eaccelerator.so\"\neaccelerator.shm_size=\"32\"\neaccelerator.cache_dir=\"/data/eacache\"\neaccelerator.enable=\"1\"\neaccelerator.optimizer=\"1\"\neaccelerator.check_mtime=\"1\"\neaccelerator.debug=\"0\"\neaccelerator.filter=\"\"\neaccelerator.shm_max=\"0\"\neaccelerator.shm_ttl=\"0\"\neaccelerator.shm_prune_period=\"0\"\neaccelerator.shm_only=\"0\"\neaccelerator.compress=\"1\"\neaccelerator.compress_level=\"9\"\n" >> /usr/local/php/etc/php.ini
#echo "OK,Eaccelerator-0.9.6.1 has  been successfully installed!"
#sleep 2

#cd ..
#echo "Start the installation of memcached..."
#sleep 2
#tar zxvf memcached-1.4.13.tar.gz && cd memcached-1.4.13 && ./configure --prefix=/usr/local/memcached --with-libevent && make && make install || exit
#echo "OK,memcached-1.4.13 has  been successfully installed!"
#sleep 2

#echo "Starting memcached,please wait...."
#sleep 2
#/usr/local/memcached/bin/memcached -d -m 256 -u root -P /tmp/memcached.pid && echo "OK,memcached is runing now" || exit 1
#echo "/usr/local/memcached/bin/memcached -d -m 256 -u root -P /tmp/memcached.pid" >> /etc/rc.d/rc.local
#sleep 2

cd .. 
echo "Start install memcache extension..."
#如果php版本为5.2，则memcache使用2.2.6版本，否则会因版本问题导致php无法加载memcach模块。
sleep 2
tar zxvf memcache-3.0.6.tgz && cd memcache-3.0.6 && /usr/local/php/bin/phpize && ./configure --enable-memcache --with-php-config=/usr/local/php/bin/php-config && make && make install || exit 1
cp /usr/local/php/lib/php/extensions/no-debug-non-zts-20090626/memcache.so /usr/local/php/ext/
echo  "OK,Memcache-3.0.6 installed successfully!"

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

cd ..
echo "Start install APC ..."
tar zxvf APC-3.1.9.tgz && cd APC-3.1.9 
/usr/local/php/bin/phpize
./configure --enable-apc --with-apc-mmap --with-php-config=/usr/local/php/bin/php-config && make && make install
cp /usr/local/php/lib/php/extensions/no-debug-non-zts-20090626/apc.so /usr/local/php/ext/
#echo -ne "[APC]\nextension = \"apc.so\"\napc.enabled = 1\napc.cache_by_default = on\napc.shm_size = 32M\napc.ttl = 600\napc.user_ttl = 600\napc.write_lock = on" >> /usr/local/php/etc/php.ini
echo -ne "APC-3.1.9 has been installed successfully!"
cd ..

#yaf.so
#yaf.so
tar zxvf yaf-2.2.7.tgz && cd yaf-2.2.7 
/usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install
cp /usr/local/php/lib/php/extensions/no-debug-non-zts-20090626/yaf.so /usr/local/php/ext/

#nginx/mysql/php auto running
echo "/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf" >> /etc/rc.d/rc.local
echo "/usr/local/php/sbin/php-fpm" >> /etc/rc.d/rc.local
#chkconfig --level 3 mysqld on
#ulimit
sed -i '$i *                -       nofile          65535\
*                soft    core            0\
*                hard    core            0' /etc/security/limits.conf

#sysctl.conf
cat sysctl.conf >> /etc/sysctl.conf && chown root:root /etc/sysctl.conf && chmod 0600 /etc/sysctl.conf

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

#vim_editor
yum install vim-enhanced
cp /etc/vimrc /root/.vimrc
echo -ne "set confirm\nset nobackup\nset noswapfile\nset hlsearch\nset incsearch\nset cmdheight=2\nlet &termencoding=&encoding\nset fileencodings=utf-8,gbk\nset autoindent\nset smartindent\nset tabstop=4\nset shiftwidth=4" >> /root/.vimrc
source /root/.vimrc
sed -i "7a alias vi='vim'" /root/.bashrc
source /root/.bashrc

echo -ne "OK,That is all!\nThanks \n"

#10秒钟后重启
for i in $(seq 10| tac)
do
	echo -ne "\aThe system will reboot after $i seconds...\r"
	sleep 1
done
echo
shutdown -r now  
