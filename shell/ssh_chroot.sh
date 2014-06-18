#! /bin/bash

# 保证openssh版本在4.8p1以上，因为新版本的openssh已经内置了chroot，老版本需要第三方支持

user=happigo
chroot_dir=/home/chroot
#添加用户
useradd -M $user
echo "123456" | passwd --stdin $user

# 构建chroot环境
mkdir -p ${chroot_dir}
 
#在/etc/ssh/sshd_config中添加chroot设置
sed -i "\$a \Match  User ${user}\n\
ChrootDirectory ${chroot_dir}" /etc/ssh/sshd_config
#重启sshd服务
service sshd restart


#一个最基本的chroot环境至少有一个shell(例如sh,bash)和一些必要的系统设备文件(例如/dev/null，/dev/zero)，如果要允许用户执行一些命令，那么还要准备相应的命令可执行文件和命令依赖的库文件。

[ "$PWD" != "${chroot_dir}" ] && cd ${chroot_dir}
mkdir {bin,dev,lib,lib64,etc,home}
mknod dev/null c 1 3
mknod dev/zero c 1 5
mknod dev/random c 1 8
mknod dev/urandom c 1 9
mknod dev/tty c 5 0

chown -R root:root ${chroot_dir}
chmod -R 755 ${chroot_dir}
chmod 0666 ${chroot_dir}/dev/{null,zero,tty}

#建立pts设备
mkdir -p ${chroot_dir}/dev/pts
mount -t devpts devpts ${chroot_dir}/dev/pts

#用户密码及组文件
grep $user /etc/passwd >> ${chroot_dir}/etc/passwd
grep $user /etc/group >> ${chroot_dir}/etc/group

# 允许用户执行的命令和这些命令依赖的库文件复制到chroot环境中。
# 要允许执行的文件列表
cmdlist="/bin/bash /bin/ls /bin/cp /bin/mkdir /bin/mv /bin/rm /usr/bin/ssh"
# chroot路径

# 依赖的库文件判断
lib_1=`ldd $cmdlist | awk '{ print $1 }' | grep "/lib" | sort | uniq`
lib_2=`ldd $cmdlist | awk '{ print $3 }' | grep "/lib" | sort | uniq`

# 复制命令文件
for i in $cmdlist
do
    cp -a $i ${chroot_dir}/bin/ && echo "$i done"
done

# 复制依赖的库文件(因为是x86_64所以是lib64,i386的则是lib)
for j in $lib_1
do
cp -f $j ${chroot_dir}/lib64/ && echo "$j done"
done

for k in $lib_2
do
cp -f $k ${chroot_dir}/lib64/ && echo "$k done"
done

#创建用户家目录
mkdir ${chroot_dir}/home/$user
chown -R $user:$user ${chroot_dir}/home/$user
chmod -R 700  ${chroot_dir}/home/$user

#现在可以以testuser用户ssh登录系统，登录以后限制在/data/chroot/目录下，家目录为/data/chroot/home/testuser,用户可使用的命令是$cmdlist所包含的命令
