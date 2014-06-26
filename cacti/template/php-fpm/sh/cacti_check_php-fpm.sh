#!/bin/sh
host=$1
port=$2
url=$3
conn=`curl -s http://${host}:${port}${url} | grep "accepted conn"`
conn=`echo $conn | awk '{print $3}'`
idle=`curl -s http://${host}:${port}${url} | grep "idle processes"`
idle=`echo $idle | awk '{print $3}'`
active=`curl -s http://${host}:${port}${url} | grep "active processes"`
active=`echo $active | awk '{print $3}'`
total=`curl -s http://${host}:${port}${url} | grep "total processes"`
total=`echo $total | awk '{print $3}'`
echo "conn:$conn idle:$idle active:$active total:$total"
