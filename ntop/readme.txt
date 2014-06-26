http://sourceforge.net/projects/ntop/files/ntop/Stable/

http://sourceforge.net/projects/ntop/files/ntop/Stable/ntop-5.0.1.tar.gz/download

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


#编译安装

yum install -y libtool automake autoconf svn gdbm-devel zlib-devel rrdtool-devel libpcap-devel openssl-devel

python版本大于2.6

#安装GeoIP
rpm -ivh ftp://rpmfind.net/linux/epel/6/i386/GeoIP-1.4.8-1.el6.i686.rpm
rpm -ivh ftp://rpmfind.net/linux/epel/6/i386/GeoIP-devel-1.4.8-1.el6.i686.rpm

tar zxvf ntop-5.0.1.tar.gz && cd ntop-5.0.1

./autogen.sh --with-tcpwrap --prefix=/usr/local/ntop

make && make install

#设置ntop环境

useradd -s /sbin/nologin ntop #增加ntop用户
chown -R ntop:ntop /usr/local/ntop/share/ntop 
cp /tmp/ntop-5.0.1/packages/RedHat/ntop.conf.sample /etc/ntop.conf
mkdir -p /var/log/ntop
chown -R ntop:root /var/log/ntop
ln -s /usr/local/ntop/bin/ntop /usr/bin/

#修改ntop管理员密码
ntop -A

#启动

ntop -d -L -u ntop --access-log-file /var/log/ntop/access.log -i eth0

#其他工作

-------后续工作-----
1.先前编译了tcpwrap功能，可以使用hosts.allow和hosts.deny来定义那些机器可以访问ntop

        echo 'ntop:192.168.0.*' >> /etc/hosts.allow  //允许主机192.168.0.* 这个网段访问NTOP服务
        echo 'ntop:ALL' >> /etc/hosts.deny	     //拒绝其它机器访问ntop 

2.开机自启动--根据需要修改如下命令，然后添加到 /etc/rc.loacl文件中

ntop -d -L -u ntop -P /var/lib/ntop --access-log-file /var/log/ntop/access.log -i eth0,eth1 -M -p /etc/ntop/protocol.list -O /var/log/ntop -n 0 & > /dev/null 2>&1
