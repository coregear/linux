#CentOS 6.4

# 安装ruby,puppet使用ruby编写
yum install ruby ruby-libs ruby-rdoc

# 修改主机名，puppet要求每台机器都有完整的域名（FQDN），如果没有DNS只能通过修改主机名及hosts，保证hostname看到的结果跟hosts文件里是一致的

# /etc/hosts
192.168.119.129 master.puppet.cn
192.168.119.128 client.puppet.cn

#/etc/sysconfig/network

HOSTNAME=master.puppet.cn


# 同步各服务器时间
ntpdate tick.ucla.edu tock.gpsclock.com

#添加puppet官方源

rpm -ivh http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-1.noarch.rpm

yum update


#服务端
yum install puppet-server

service puppet start  # 把自己也作为一个客户端管理起来
service puppetmaster start

#客户端
yum install puppet

service puppet start

#修改/etc/puppet/puppet.conf，添加如下行

server = master.puppet.cn  #设定服务端的地址


#生成证书并发送给服务器进行签名
puppet agent  --no-daemonize --verbose


#服务器端操作

puppet cert --sign node08.chenshake.com  #签发证书

puppet cert list --all #查看所有证书，证书前有+符号的是已经通过签名认证的

puppet cert revoke node08.chenshake.com # 注销证书

puppet cert --clean node08.chenshake.com # 清除证书，无论注销还是清除都需要重启puppetmaster服务

# 客户端消除证书，重新申请
rm -f /var/lib/puppet/ssl/certs/node08.chenshake.com.pem

rm -rf /var/lib/puppet/ssl