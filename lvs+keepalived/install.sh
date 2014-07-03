# CentOS-6

yum install kernel-devel

yum install popt popt-devel popt-static libnl libnl-devel

tar zxvf ipvsadm-1.26.tar.gz && cd ipvsadm-1.26

make && make install


####real_server的sysctl.conf######

##必须关闭arp解析功能##
net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2




#keepalived

tar zxvf keepalived-1.2.8.tar.gz && cd keepalived-1.2.8

./configure && make && make install

cp /usr/local/etc/rc.d/init.d/keepalived /etc/init.d/

cp /usr/local/etc/sysconfig/keepalived  /etc/sysconfig/

mkdir /etc/keepalived

cp /usr/local/etc/keepalived/keepalived.conf /etc/keepalived/

cp /usr/local/sbin/keepalived /usr/sbin/
