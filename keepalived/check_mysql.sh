#!/bin/bash
while true
do
onmysqld=$(ss -at | grep ":3306") 
if [ "$onmysqld" == "" ];then 
/etc/init.d/keepalived stop 
exit 1 
fi 
sleep 2 
done 
