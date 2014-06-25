rsync --daemon --config=/etc/rsyncd/rsyncd.conf


如果出现rsync客户端不能连接server端，报告类似"UNKNOW HOST" 的错误，将客户端的ip和主机名加入到rsync server端的hosts文件即可