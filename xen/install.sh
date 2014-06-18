##CentOS-

#依赖包安装
yum install hmaccalc ncurses-devel zlib-devel openssl-devel python-devel bridge-utils libtool-ltdl iasl xorg-x11-drv-evdev xorg-x11-drv-fbdev xorg-x11-drv-i810-devel xorg-x11-drv-via-devel xorg-x11-proto-devel xorg-x11-server-sdk xorg-x11-xtrans-devel

# flex  bison(安装acpica需要)
yum install flex bison

#安装acpi ca (https://acpica.org/downloads)
#这里曾尝试安装最新版，但未成功，遇到各种问题，能通过的最高版本为acpica-unix-20130823.tar.gz

tar zxvf acpica-unix-20130823.tar.gz && cd acpica-unix-20130823
make 
make install

# 安装 Xen hypervisor 和 tools

# 首先安装依赖包：（dev86、uuid、glib、yajl、git、texinfo)
#wget  http://rdebath.nfshost.com/dev86/Dev86bin-0.16.19.tar.gz

#tar zxvf Dev86bin-0.16.19.tar.gz  && cd  usr

#cp lib/* /usr/lib
#cp bin/* /usr/binyum install dev86yum install libuuid libuuid-devel
yum install glib2 glib2-devel
yum install yajl yajl-devel
yum install git
yum install texinfo
#xen安装过程中会使用git下载数据，保持网络可用

#xen安装

tar zxvf  xen-4.3.1.tar.gz  && cd xen-4.3.1

make xen tools stubdom

make install-xen install-tools install-stubdom


# 编译linux内核，使之支持xen

xz -d linux-3.11.8.tar.xz && tar xvf linux-3.11.8.tar && cd linux-3.11.8

make menuconfig

#选中以下项

Processor type and features--> Linux guest support--> Xen guest support

Device Drivers-->Network device support-->Xen network device frontend driver/Xen backend network device

Device Drivers-->Block devices-->Xen virtual block device support/Xen block-device backend driver

Device Drivers-->Xen driver support

make

make modules

make modules_install

make install

depmod 3.11.8

# 修改引导文件，使用xen启动系统

vi /etc/grub.conf

title CentOS6.0 (linux-3.11.8-xen)
kernel /xen.gz               
module /vmlinuz-3.11.8 ro root=/dev/sda3
module /initramfs-3.11.8.img

# 如果/boot不是单独分区的话，kernel /boot/xen.gz  modules /boot/vmlinuz-3.11.8

# 重启系统

reboot
