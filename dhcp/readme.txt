wget ftp://ftp.isc.org/isc/dhcp/4.2.4rc2/dhcp-4.2.4rc2.tar.gz

tar zxvf dhcp-4.2.4rc2.tar.gz

cd dhcp-4.2.4rc2

./configure && make && make install

#确认广播路由，要想通过eth0广播DHCP服务信息，必须将eth0加入广播路由表，即： 

route add -host 255.255.255.255 dev eth0

#创建配置文件

touch /etc/dhcpd.conf

ddns-update-style none;

ignore client-updates;
subnet 192.168.127.0 netmask 255.255.255.0 {
        option routers 192.168.127.2;
        option subnet-mask 255.255.255.0;
        option domain-name "ipw.com";
        option domain-name-servers 192.168.127.2;
        range 192.168.127.139 192.168.127.150;
        default-lease-time 21600;
        max-lease-time 43200;
	#固定ip分配
        #host ipw2 {
        #       hardware ethernet 00:0C:29:8F:81:FB;
        #       fixed-address 192.168.127.130;
        #}
}

#创建dhcpdhcp租期的记录文件，已经分配的客户端会记录在这里

touch /var/db/dhcpd.leases

/usr/local/sbin/dhcpd  #启动服务