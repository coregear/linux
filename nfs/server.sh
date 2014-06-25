#安装
yum install portmap # 从centos6开始 portmap 变成rpcbind
yum install nfs-utils

#centos6 安装

yum install nfs-utils prcbind
#设置共享目录，共享参数是重点，这些参数中有部分参数在CENTOS6的新版本NFS中不再可用，比如no_root_suqash no_hide，应该是出于安全性考虑
vi  /etc/exports
/data/nfs  10.0.8.2(rw,ro,sync,async,secure,insecure,root_suqash,no_root_suqash,all_suqash,anonuid=,anongid=,hide,no_hide,subtree_check,no_subtree_check) #注意这里是空格  *(ro)

#anonuid  anongid这两个参数指定了匿名访问nfs目录的用户uid,当在客户端用root访问挂载的nfs目录是，root的身份会被自动映射为一个普通用户，默认这个用户是nfsnobody,如果服务端的exports文件设置了anonuid参数，则root会映射为anonuid指定的那个用户

#启动服务
service portmap/rpcbind start
service nfs start

#管理
showmount -e  localhost #显示共享信息
exportfs -ar  #重新加载exprots文件，使新的挂载参数生效
