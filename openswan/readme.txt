#试验环境 Centos5.6,最高可使用2.6.38，版本再高则无法编译通过####

###在CentOS6.4上2.6.40可以编译通过，应该是已内核版本2.6.23为界####
##download from  https://download.openswan.org/openswan/ ####

###deps#####
yum install gmp-devel flex bison-devel

tar zxvf openswan-2.6.38.tar.gz && cd openswan-2.6.38 && make programs && make install

uname -r 查看一下内核版本
export KERNELSRC= /usr/src/kernels/2.6.32-220.17.1.el6.x86_64/##这里的目录选择以上一步uname-r 的结果为准
make module && make minstall
depmod -a
modprobe ipsec

ipsec --version
Linux Openswan U2.6.38/K(no kernel code presently loaded)
See `ipsec --copyright' for copyright information.

###start####
service ipsec start

###sysctl.conf#####  sysctl -a | egrep "ipv4.*(accept|send)_redirects" | awk -F "=" '{print $1"= 0"}' >> /etc/sysctl.conf


net.ipv4.ip_forward = 1 
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.lo.accept_redirects = 0
net.ipv4.conf.lo.send_redirects = 0
net.ipv4.conf.em1.accept_redirects = 0
net.ipv4.conf.em1.send_redirects = 0
net.ipv4.conf.em4.accept_redirects = 0
net.ipv4.conf.em4.send_redirects = 0
net.ipv4.conf.em3.accept_redirects = 0
net.ipv4.conf.em3.send_redirects = 0
net.ipv4.conf.em2.accept_redirects = 0
net.ipv4.conf.em2.send_redirects = 0

######test#######
ipsec verify


##################生成key(左右两端命令一样)#####
mv  /dev/random  /dev/random.back
ln -s  /dev/urandom  /dev/random
ipsec newhostkey --output /etc/ipsec.secrets 

###/etc/ipsec.secrets添加以下内容,两段公网ip ，123456是共享密钥##
118.145.0.38 118.144.83.20:PSK "123456"


