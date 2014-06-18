要求：

openssh版本大于5

yum install pam pam-devel

#如果openssh版本过低，升级openssh

wget http://openbsd.org.ar/pub/OpenBSD/OpenSSH/portable/openssh-5.8p2.tar.gz

tar zxvf openssh-5.8p2.tar.gz && cd openssh-5.8p2 


./configure --prefix=/usr --sysconfdir=/etc/ssh --with-pam --with-zlib --with-ssl --with-md5-passwords --mandir=/usr/share/man && make && make install


# 配置sftp,将www用户限制在/data/www目录中,注意把目标目录的上级目录，也就是本例中的/data目录的所有者设置为root


vi /etc/ssh/sshd_config

# Subsystem   sftp    /usr/libexec/openssh/sftp-server

Subsystem   sftp  internal-sftp
Match User www
X11Forwarding no
ChrootDirectory /data/www
AllowTcpForwarding no
ForceCommand internal-sftp

#设置目录权限
chown root:root /data  #上级目录所有者为root
chown www:www /data/www  #目标目录所有者设置为www，保证www用户对此目录有完全权限

#设置www用户的密码

passwd www

#重启sshd
service sshd restart












##如果需要升级openssl则如下操作

wget  http://www.openssl.org/source/openssl-1.0.1g.tar.gz



tar zxvf openssl-1.0.1g.tar.gz
cd openssl-1.0.1g
./config shared zlib
make
make install
mv /usr/bin/openssl /usr/bin/openssl.OFF
mv /usr/include/openssl /usr/include/openssl.OFF
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl

