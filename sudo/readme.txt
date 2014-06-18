sudo 切换到root之后未获取root的环境变量，还是原来用户的环境变量

#####

visudo

主要是以下两个选项：

Defaults    always_set_home   #切换后自动更换家目录，因为环境变量的设置其实就是读取几个启动文件，（/etc/profile  /etc/bashrc ~/.bashrc等几个登录文件）切换家目录才能重新设置环境变量


Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin  # 是否允许sudo之后直接使用这几个路径下的命令，如果没有这个参数，sudo之后将不能直接使用，必须以全路径方式使用