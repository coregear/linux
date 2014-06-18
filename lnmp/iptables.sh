#!/bin/bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
iptables -A INPUT -i lo -j ACCEPT 
iptables -A OUTPUT -o lo -j ACCEPT 
#开放http
iptables -A INPUT -i eth0 -p tcp -m tcp --dport 80 -j ACCEPT 
iptables -A OUTPUT -p tcp -m tcp --sport 80  -m state --state ESTABLISHED,RELATED -j ACCEPT
#开放ssh
iptables -A INPUT -i eth0 -p tcp --syn -m state --state NEW --dport 22 -j ACCEPT 
#封包状态
iptables -A INPUT -i eth0 -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i eth0 -p all -m state --state INVALID -j DROP
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -A OUTPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
#dns
iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 53 -j ACCEPT
#开放邮件发送
iptables -A OUTPUT -p tcp -m state --state NEW --dport 25 -j ACCEPT 
#允许服务器发起http请求
iptables -A OUTPUT -p tcp -m state --state NEW --dport 80 -j ACCEPT 

