tar zxvf fwknop-2.0.4.tar.gz

cd fwknop-2.0.4

yum install gpgme-devel #  GPG encryption support:     yes

yum install texinfo  # makeinfo: command not found

./configure && make && make install 

默认安装位置/usr/local/bin/fwknop(client)     /usr/local/sbin/fwknopd(server)


