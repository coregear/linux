#安装apr
tar jxvf apr-1.5.0.tar.bz2  && cd apr-1.5.0

sed -i '/$RM "$cfgfile"/ s/^/#/' configure

./configure --prefix=/usr/local/apr

 make && make install

#安装apr-util
tar jxvf apr-util-1.5.3.tar.bz2 && cd  apr-util-1.5.3

./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/bin/apr-1-config

make && make install

#安装pcre
tar jxvf pcre-8.34.tar.bz2 && cd pcre-8.34

 ./configure --prefix=/usr/local/pcre
 
 make && make install

#升级openssl
tar zxvf openssl-1.0.1g.tar.gz
cd openssl-1.0.1g

./config shared zlib
make && make install

mv /usr/bin/openssl /usr/bin/openssl.OFF
mv /usr/include/openssl /usr/include/openssl.OFF
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl

#安装apache

tar jxvf httpd-2.4.7.tar.bz2 && cd httpd-2.4.7
 ./configure --prefix=/usr/local/apache2 --sysconfdir=/etc/httpd --with-apr=/usr/local/apr/bin/apr-1-config --with-apr-util=/usr/local/apr-util/bin/apu-1-config  --with-pcre=/usr/local/pcre/ --enable-so --enable-mods-shared=most --enable-rewirte  --enable-ssl=shared --with-ssl=/usr/local/ssl
 
 make && make install


#安装sqlite
tar zxvf sqlite-autoconf-3080403.tar.gz  && cd   sqlite-autoconf-3080403

./configure --prefix=/usr/local/sqlite

make && make install

#安装svn
tar  jxvf subversion-1.8.9.tar.bz2 && cd  subversion-1.8.9

./configure --prefix=/usr/local/subversion --with-apxs=/usr/local/apache2/bin/apxs --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util/ --with-sqlite=/usr/local/sqlite/

make && make install

make install-tools  #在安装目录下生成svn-tools目录，里边有一些扩展工具，比如svnauthz-validate

#为apache添加模块

cp   libexec/mod_authz_svn.so  /usr/local/apache2/modules/
cp   libexec/mod_dav_svn.so  /usr/local/apache2/modules/

#向httpd.conf添加：
LoadModule dav_module modules/mod_dav.so
LoadModule dav_svn_module modules/mod_dav_svn.so
LoadModule authz_svn_module modules/mod_authz_svn.so

#去掉Include /etc/httpd/extra/httpd-vhosts.conf行前注释使之生效

#在httpd-vhosts.conf添加虚拟主机：
<VirtualHost *:80>
    ServerName svn.happigo.com
    <Location /svn>                         #这里的/svn要区别于Alias目录别名
        DAV svn
        SVNParentPath /data/svn      #svn版本库根目录,根目录下有多个版本库使用SVNParentPath,单个版本库可使用SVNPath
        AuthType Basic
        AuthName "Subversion repository"    #验证页面提示信息
        AuthUserFile /data/svn/passwd          #用户名密码
        Require valid-user                              # 只允许通过验证的用户访问
        AuthzSVNAccessFile /data/svn/authz  #版本库权限控制
    </Location>
</VirtualHost>
# 创建passwd及authz文件

# 创建认证文件

# 用户名密码文件：
/usr/local/apache2/bin/htpasswd -c  /data/svn/passwd  user1  #首次添加用户，再添加用户使用-m参数即可

# 版本库权限认证文件

vi  /data/svn/authz  #按照svn版本库下的authz文件格式编辑权限即可

#  创建版本库

/usr/local/subversion/bin/svnadmin  create /data/svn/happigo

# 访问
http://svn.happigo.com/svn/happigo


# 配置apache  https

# 服务器要安装了openssl,上边的步骤中已经安装过

# apache要加载ssl模块或者安装apache的时候已经使用enable-ssl静态包含了ssl

#httpd.conf中去掉如下行的注释，使之生效
LoadModule ssl_module modules/mod_ssl.so
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
Include /etc/httpd/extra/httpd-ssl.conf

#编辑httpd-ssl.conf文件

<VirtualHost _default_:443>
ServerName svn.happigo.com:443
<Location /svn>
        DAV svn
        SVNParentPath /data/svn
        AuthType Basic
        AuthName "Subversion repository"
        AuthUserFile /data/svn/passwd
        Require valid-user
        AuthzSVNAccessFile /data/svn/authz
</Location>
SSLEngine on
SSLCertificateFile "/etc/httpd/server.crt"     
SSLCertificateKeyFile "/etc/httpd/server.key"
</VirtualHost >

# 生成ssl证书
openssl genrsa  -out  server.key 1024

openssl req -new   -key server.key  -out server.csr  

openssl req -x509 -days 365 -key server.key -in server.csr  -out  server.crt

#将生成的三个文件放到/et/httpd目录下（/etc/httpd目录是上一步httpd-ssl.conf中指定的）

# 重启apache服务

#访问

https://svn.happigo.com/svn/happigo

#注意在这种模式下（svn服务并不启动，通过http或https来管理svn），向svn提交数据的时候要保证用来运行apache的用户对svn版本库目录有读写权限，不然会遇到“db/txn-current-lock': Permission denied” 的错误
