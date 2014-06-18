./configure --prefix=/usr/local/bind/ --with-openssl=/usr/ --sysconfdir=/etc/ --with-libtool --enable-threads


--prefix=/usr/local/bind                          #指定bind9的安装目录,默认是/usr/local

--enable-threads                                  #开启多线程的支持；如果你的系统有多个CPU，那么可以使用这个选项

--disable-openssl-version-check                   #关闭openssl的检查

--with-openssl=/usr/local/openssl                 #指定openssl的安装路径

--sysconfdir=/etc/                           #设置named.conf配置文件放置的目录，默认是--prefix选项指定的目录下的/etc下

--localstatdir=/var                               #设置 run/named.pid 放置的目录，默认是--prefix选项指定的目录下的/var下

--with-libtool                                    #BIND的库文件编译为动态共享库文件，这个选项默认是未选择的。 如果不选这个选项，那么编译后的named命令会比较大，lib目录                                                     中的库文件都是.a后缀的 


--disable-chroot                                  #禁用chroot，不建议使用，默认开启此功能


make && make install


#添加系统变量

vi  ~/.bash_profile

PATH=$PATH:$HOME/bin:/usr/local/bind/bin:/usr/local/bind/bin:/usr/local/bind/sbin  #修改本行

source ~/.bash_profile  #使修改生效
 
#添加运行用户

useradd -r named  # -r 添加系统用户

#启用chroot

mkdir  -p /var/named/chroot/{var,etc,dev}
mkdir /var/named/chroot/var/run

#创建虚拟设备

cd /var/named/chroot/dev

mknod random c 1 8 
mknod zero c 1 5 
mknod null c 1 3

#修改run目录属主
chown -R named:named  /var/named/chroot/var/run   #named 要向run目录写入pid文件


#生成rndc.conf ，以便使用rndc命令管理bind
rndc-confgen

将生成的内容分别写入/etc/named.conf和/etc/rndc.conf #这里在测试中，named.conf是写入chroot之后的etc而rndc.conf写如chroot之后的etc却提示找不到，写入真实的/etc下则正常

#创建配置文件

vi /var/named/chroot/etc/named.conf

key "rndc-key" {
       algorithm hmac-md5;
       secret "BM+rI8Ra3mpKKtIlYpGEAQ==";
 };

controls {
       inet 127.0.0.1 port 953
       allow { 127.0.0.1; } keys { "rndc-key"; };
};
options {
    directory "/var";
    pid-file  "/var/run/named.pid";
    version   "bind 9.9.3";
    allow-query {any;};
    forwarders {                 #如果想让dns同时可以解析外网，可使用forward功能；
    	192.168.1.253;
    };

};

zone "." IN {
    type hint;
    file "named.root";
};

zone "lxy.com" IN {
        type master;
        file "named.lxy.com";
};


vi /etc/rndc.conf

key "rndc-key" {
       algorithm hmac-md5;
       secret "BM+rI8Ra3mpKKtIlYpGEAQ==";
};
options {
        default-key "rndc-key";
        default-server 127.0.0.1;
        default-port 953;
};


#ZONE文件内容：

vi /var/named/chroot/var/named.lxy.kk     #正解析的zone，如果想让dns可以解析外网，就不要包含.com等合法域，不然在试图解析合法域名的时候服务器会在本地寻找记录，当然是找					   不到的，它会告诉你找不到，而不会去向forward请求。

$TTL    86400
@    IN    SOA    lxy.kk. root.lxy.kk. (
                    2008080804    ;
                    28800        ;
                    14400        ;
                    3600000        ;
                    86400    )    ;
@        IN    NS   dns.lxy.kk.
@        IN    MX    10    mail.lxy.kk.
dns      IN    A    192.168.127.129
mail     IN    A    192.168.127.130
www            IN    A     192.168.127.129


vi /var/named/chroot/named.127.0.0    #反向解析的zone

$TTL    86400
@    IN    SOA    dns.lxy.kk. root.lxy.kk. (
                    2008080804    ;
                    28800        ;
                    14400        ;
                    3600000        ;
                    86400    )    ;
@        IN    NS   dns.lxy.kk.
1    IN     PTR     localhost.



#启动服务

named  -c /etc/named.conf -t /var/named/chroot -u named  #注意这里的/etc/实际指的是chroot下的etc,因为已经使用-t指定了chroot到的目录，named将视chroot为根目录


#rndc

rndc reload | status等