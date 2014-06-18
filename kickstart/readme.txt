kickstart服务器

#安装http/vsftp/nfs(pxe支持以其中任意一种方式获取安装文件)

#安装dhcp

ddns-update-style none;

ignore client-updates;
subnet 192.168.127.0 netmask 255.255.255.0 {
        option routers 192.168.127.2;
        option subnet-mask 255.255.255.0;
        option domain-name "ipw.com";
        option domain-name-servers 192.168.127.2;
        range 192.168.127.139 192.168.127.150;
        filename "pxelinux.0"    #这是重要的，pxe client会向dhcp服务器请求ip地址并连接dhcp服务器上的tftp服务器，并把pxelinux.0(bootloader)取回本地执行。
	default-lease-time 21600;
        max-lease-time 43200;
	#固定ip分配
        #host ipw2 {
        #       hardware ethernet 00:0C:29:8F:81:FB;
        #       fixed-address 192.168.127.130;
        #}
}

#安装tftp

yum install tftp-server

vi /etc/xinetd.d/tftp

# default: off
# description: The tftp server serves files using the trivial file transfer \
#       protocol.  The tftp protocol is often used to boot diskless \
#       workstations, download configuration files to network-aware printers, \
#       and to start the installation process for some operating systems.
service tftp
{
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -s /var/lib/tftpboot
        disable                 = no  #这里改为no,让tftp随xinetd启动
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}

#启动xinetd

/etc/init.d/xinetd start

#挂载ISO镜像

mount -o loop /path/xxx.iso  /data/www/centos #这里用的是http方式

#复制必要文件到tftpboot

cp /usr/share/syslinux/pxelinux.0  /var/lib/tftpboot  #用于pxe方式的bootloader,需要安装syslinux(yum install syslinux)

cp /data/www/centos/images/pxeboot/initrd.img /var/lib/tftpboot 

cp /data/www/centos/images/pxeboot/vmlinuz /var/lib/tftpboot

# 创建bootloader,也就是pxelinux.0所需要的参数文件，没有参数文件，则安装只能停留在boot>界面

mkdir /var/lib/tftpboot/pxelinux.cfg

cp /data/www/centos/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default  #bootloader要到哪加载操作系统内核来启动安装？就是在这个文件里指定的。

#derault的内容

default text
prompt 1
timeout 600

display boot.msg

menu background splash.jpg
menu title Welcome to CentOS 6.4!
menu color border 0 #ffffffff #00000000
menu color sel 7 #ffffffff #ff000000
menu color title 0 #ffffffff #00000000
menu color tabmsg 0 #ffffffff #00000000
menu color unsel 0 #ffffffff #00000000
menu color hotsel 0 #ff000000 #ffffffff
menu color hotkey 7 #ffffffff #ff000000
menu color scrollbar 0 #ffffffff #00000000

label text
kernel vmlinuz
append ks=http://192.168.127.129/ks.cfg initrd=initrd.img #这里告诉了bootloader要加载的内核文件，启动安装。然后告诉客户端ks.cfg在哪里，ks.cfg则告诉安装程序到哪寻找安装文件，以及需要安装哪些套件，或者在安装完成后需要执行哪些操作。


所以pxe安装的流程是这样的：

客户端网卡启动pxe程序请求ip地址，分配到ip地址后启动tftp从服务端获取bootloader,有了bootloader就进到了安装界面，但是要加载的内核文件在哪？pxelinux.0的参数文件也就是default来告诉它。加载到了内核文件就可以启动安装了，但是所需要的安装文件在哪？于是default文件里指定了ks=xxxx/ks.cfg,ks.cfg的作用就是告诉安装程序到哪里去寻找安装文件、都是需要安装哪些套件以及安装过程中所做的操作，比如分区、格式化、安装语言、时区选择等等。



所以依次加载的文件是 pxelinux.0  --> default --->ks.cfg
#kickstart选项说明
http://man.ddvip.com/os/redhat9.0cut/s1-kickstart2-options.html

