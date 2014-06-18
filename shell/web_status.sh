#! /bin/bash
# web_status.sh
# This script get operational state of nginx and php
# edited by shidg at 20140219

# Create Temporary Files
TMPFILE1=`mktemp nginx.XXXX`
TMPFILE2=`mktemp php.XXXX`

# Get the current date and time
DATE=`date +%Y%m%d-%T`

#Get local ip
IP=`ifconfig | grep inet | grep -v 127.0.0.1|grep -v inet6 |awk '{print $2}' | cut -d : -f2`

#The result will be recorded to the this file
RESULT=status.$DATE

#NGINX
ss -an | grep ":80" > $TMPFILE1

echo "Time: $DATE" > $RESULT
echo -e "Server:$IP\n">>$RESULT
echo -e "Part 1,nginx\n">>$RESULT
echo -ne "Total connections of nginx:" >> $RESULT
cat -n $TMPFILE1 | tail -n 1 | awk '{print $1}' >> $RESULT

echo "Connections top 20:" >> $RESULT
awk '{print $5}' $TMPFILE1 | cut -d : -f 1 | sort | uniq -c | sort -k 1 -nr | head -n 20 >> $RESULT

echo "Connection Status:" >> $RESULT
awk '{print $1}' $TMPFILE1 | sort |uniq -c >> $RESULT

#PHP
ss -an | grep ":9000" > $TMPFILE2

echo -e "\n" >> $RESULT
echo -e "Part 2,php\n">>$RESULT
echo -ne "Total connections of php:" >> $RESULT
cat -n $TMPFILE2 | tail -n 1 | awk '{print $1}' >>$RESULT

echo "Connection Status:" >> $RESULT
awk '{print $1}' $TMPFILE2 | sort |uniq -c >> $RESULT

echo -e "\n" >> $RESULT

echo -e "Part 3 ,system status:\n" >> $RESULT
echo -e "Physical Memory:(MB)" >> $RESULT
echo -ne "Total:" >> $RESULT
free -m | sed -n '2p' | awk '{print $2}' >>$RESULT
echo -ne "Used:" >> $RESULT
free -m | sed -n '3p' | awk '{print $3}' >>$RESULT

echo -e "\nload average:" >> $RESULT
#load average:
echo -n "Current load:" >> $RESULT
uptime |awk -F , '{print $4}'| cut -d : -f 2 >>$RESULT
echo -n "5 minutes averages:" >> $RESULT
uptime |awk -F , '{print $5}' >>$RESULT
echo -n "15 minutes averages:" >> $RESULT
uptime |awk -F , '{print $6}' >>$RESULT

#delete tmpfile
rm -f $TMPFILE1
rm -f $TMPFILE2

echo -e "\nThe End" >> $RESULT

#End