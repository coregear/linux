#!/bin/bash
if [ $(id -u) != 0 ];then
echo "Must be root can do this."
exit 9
fi
# set privileges
chmod 600 /etc/shadow
chmod 600 /etc/gshadow

# Turn off unnecessary services
service=($(ls /etc/init.d/))
for i in ${service[@]}; do
case $i in
sshd|network|syslog|iptables|crond)
chkconfig $i on;;
*)
chkconfig $i off;;
esac
done
#set ulimit
cat >> /etc/security/limits.conf << EOF
* soft nofile 65535
* hard nofile 65535
EOF
# set sysctl
cat > /etc/sysctl.conf << EOF
#不充当路由器
net.ipv4.ip_forward = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# 避免放大攻击
net.ipv4.icmp_echo_ignore_broadcasts = 1
# 开启恶意icmp错误消息保护
net.ipv4.icmp_ignore_bogus_error_responses = 1

# 处理无源路由的包
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

# 开启反向路径过滤
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1


# 开启并记录欺骗，源路由和重定向包
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# 禁止修改路由表
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0


kernel.sysrq = 0
kernel.core_uses_pid = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 1024 65535
vm.swappiness = 0
EOF

#修改ssh端口为5122
sed  -i '/22$/ {s/^# //;s/22/5122/}' /etc/ssh/sshd_config
#iptables

#定义变量
IPTABLES=/sbin/iptables

#清除filter表中INPUT OUTPUT FORWARD链中的所有规则，但不会修改默认规则。
$IPTABLES -F
#清除filter表中自定义链中的所有规则
#$IPTABLES -X
#$IPTABLES -Z
$IPTABLES -A INPUT -m conntrack --ctstate INVALID -j DROP
$IPTABLES -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -A INPUT -i lo -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 5122 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 80 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p udp -m udp -s 10.10.38.238 --dport 161 -j ACCEPT
$IPTABLES -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
$IPTABLES -P INPUT DROP
$IPTABLES -A OUTPUT -m conntrack --ctstate INVALID -j DROP
$IPTABLES -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -A OUTPUT -o lo -j ACCEPT
$IPTABLES -A OUTPUT -p tcp -m tcp --dport 25 -m conntrack --ctstate NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp -m tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
$IPTABLES -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
$IPTABLES -A OUTPUT -p udp -m udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT
$IPTABLES -A OUTPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
$IPTABLES -P OUTPUT DROP
$IPTABLES -P FORWARD DROP

service iptables save
#history
sed -i '/^HISTSIZE/ a \export HISTFILESIZE=10000000\
export PROMPT_COMMAND="history -a"\
export HISTTIMEFORMAT="%Y-%m-%d_%H:%M:%S `whoami` "\
export HISTIGNORE="pwd:ls:ll:ls -al:"\
export HISTCONTROL="ignoredups"' /etc/profile


#仅wheel组成员可以使用su,防止其他成员直接使用su - 切换root身份，，该限制不会影响sudo命令，只限制su 命令
sed -i '/required/ s/^#//' /etc/pam.d/su
echo "SU_WHEEL_ONLY  yes" >> /etc/login.defs

source /etc/profile
# time
echo "*/180 * * * * ( /usr/sbin/ntpdate tick.ucla.edu tock.gpsclock.com ntp.nasa.gov timekeeper.isi.edu ;)> /dev/null 2>&1" >>/var/spool/cron/root
echo "All things is init ok! "
