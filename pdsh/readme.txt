tar jxvf pdsh-2.26.tar.bz2 && cd pdsh-2.26

./configure --with-ssh --without-rsh --with-dshgroups && make && make install


pdsh -R ssh -w 192.168.119.130 [-l root] uptime
pdsh -R ssh -w 192.168.119.13[0-9] -x 192.168.119.135 uptime
#-x 排除

#定义主机组,配置文件为 /etc/dsh/group/webs或者~/.dsh/group/webs

pdsh -R ssh -g webs [-l root] uptime


#pdcp，前提需要每个节点也安装pdsh

pdcp -R ssh -g webs  /home/1 /tmp/

#添加一条别名  alias pdsh='pdsh -R ssh'可以简化操作
 