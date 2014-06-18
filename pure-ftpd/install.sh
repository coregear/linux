#获取软件
wget http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.36.tar.gz

#安装
tar zxvf pure-ftpd-1.0.36.tar.gz && cd pure-ftpd-1.0.36
 ./configure --prefix=/usr/local/pure-ftpd --with-puredb --with-ftpwho --with-welcomemsg --with-virtualhosts --with-virtualchroot --with-diraliases --with-language=english --with-rfc2640 --with-tls  --with-certfile=/etc/ssl/private/pure-ftpd.pem

make && make install

#参数说明
--with-tls     开启ssl认证支持
--with-certfile:使用的ssl证书存放位置,/etc/ssl/private/是缺省位置，如果使用缺省位置该参数可以省略


#生成ssl证书
mkdir -p /etc/ssl/private

openssl req -x509 -nodes -newkey rsa:1024 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem

chmod 600 /etc/ssl/private/pure-ftpd.pem

#修改pure-ftpd.conf

TLS  2   仅接受加密认证 
