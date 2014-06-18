#!/bin/bash
echo "[+] Setting up Defult policy..."
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

echo "[+] Setting up INPUT chain..."
-A INPUT  -m state --state INVALID -j LOG --log-prefix "DROP VALID"  --log-ip-optioins --log-tcp-options
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -i lo -j ACCEPT 
#开放http
iptables -A INPUT -i eth0 -p tcp --dport 80  --syn -m state --state NEW -j ACCEPT 
#开放ssh
iptables -A INPUT -i eth0 -p tcp --dport 22 --syn -m state --state NEW  -j ACCEPT 
#ICMP
iptables -A INPUT -P icmp --icmp-type echo-request -j ACCEPT

#SYN洪水攻击
#iptables -A INPUT -p tcp –syn -m limit –limit 1/s -j ACCEPT
#屏蔽 SYN_RECV 的连接
#iptables -A INPUT -p tcp  –tcp-flags SYN,RST,ACK SYN -m limit –limit 1/sec -j ACCEPT

#封包状态
iptables -A INPUT -i eth0  -m state --state ESTABLISHED,RELATED -j ACCEPT

echo "[+] Setting up OUTPUT chain..."
iptables -A OUTPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID" --log-ip-options --log-tcp-options
iptables -A OUTPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -o lo -j ACCEPT 
#dns
iptables -A OUTPUT -p udp --dport 53 -m state --state NEW -j ACCEPT
#开放邮件发送
iptables -A OUTPUT -p tcp  --dport 25 --syn -m state --state NEW -j ACCEPT 
#允许服务器发起http请求
iptables -A OUTPUT -p tcp --dport 80 --syn -m state --state NEW -j ACCEPT 
#ICMP 
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
#封包状态
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables save
echo "[+] Done."


