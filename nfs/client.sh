#客户端同样需要启动portmap,centos6之后是rpcbind
service  (portmap|rpcbind)  start


showmount -e (ip)  #扫描服务器共享信息

#挂载服务器共享目录到本地，挂载参数可控
mount -t nfs -o rw,ro,bg,fg,nosuid,nodev,noexec,soft,hard,intr,rsize=,wsize=  ip:/data/nfs  /mnt

#autofs自动挂载
#主要配置文件 auto.master
vi  /etc/auto.master
/home   /etc/auto.nfs  #auto.nfs文件名为自定义

#具体配置文件 auto.nfs
vi  /etc/auto.nfs

public  -rw,bg,soft,rsize=2048,wsize=2048  10.0.8.2:/data/pub
software  -ro,bg,soft,rsize=2048,wsize=2048  10.0.8.2:/data/software
……
#当试图读取本机的/home/public目录时，本机就会自动去挂载10.0.8.2上的/data/public目录，挂载的参数就是以"-"开头的那几个参数。而超过一定时间不使用，系统又会自动卸载这个远程挂载。

service autofs start
