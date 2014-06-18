NFS主要用到的端口有：
111- portmapper (tcp/udp)
875 - rquotad (tcp/udp)
2049-nfs (tcp/udp)
udp:32769-nlockmgr
tcp 32803-nlockmgr
892-mountd (tcp/udp)
分别把以上端口（程序所用端口）加入iptables允许其通过即可。