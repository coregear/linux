wget http://www.keepalived.org/software/keepalived-1.2.10.tar.gz

yum install popt-devel openssl openssl-devel libnl-devel

tar zxvf keepalived-1.2.10.tar.gz  &&  cd keepalived-1.2.10

./configure --prefix=/usr/local/keepalived

make

make install

cp /usr/local/keepalived/sbin/keepalived  /usr/sbin
cp /usr/local/keepalived/etc/rc.d/init.d/keepalived  /etc/init.d/keepalived
cp /usr/local/keepalived/etc/sysconfig/keepalived   /etc/sysconfig/

mkdir /etc/keepalived

touch /etc/keepalived/keepalived.conf
