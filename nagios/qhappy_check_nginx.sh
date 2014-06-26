#!/bin/bash
#
PROGNAME=`basename $0`
VERSION="Version 1.0,"
AUTHOR="2011, Qhappy (http://www.9ai9.net/) lxy1234@163.com"

#exit status
ST_OK=0
ST_WR=1
ST_CR=2
ST_UK=3

function PrintHelp(){
        echo "A This Program is a plug  of nagios to monitor WebServer , special for Nginx!";
        echo "This Program base on  WebServer's respond status report an emergency ";
        echo "It usefull on nginx repond 502 and 504 status";
        echo "$AUTHOR";
        echo "How to use Eg 1";
        echo "$PROGNAME --url http://www.9ai9.net/index.php";
        echo "How to use Eg 2";
        echo "$PROGNAME -host www.9ai9.net --url http://174.36.186.59/index.php";
        echo "www.9ai9.net and 174.36.186.69 replace of you site and IP!"
}

while test -n "$1";do
        case "$1" in
                --help|-h)
                        PrintHelp
                        exit $ST_UK
                        ;;
                --url|-u)
                        URL=$2
                        shift
                        ;;
                --host|-H)
                        HOST=$2
                        shift
                        ;;
                *)
                        echo "fail"
                        exit $ST_UK
                        ;;
        esac
        shift
done

if [  -n "$HOSTNAME" ] ;then
        HTTP_STATUS=`curl -s -I  "$URL" |head -n1|awk '{print $2}'`
else 
        HTTP_STATUS=`curl -s -I host:$HOSTNAME "$URL"|head -n1|awk '{print $2}'`
fi
if [ ! -n "$HTTP_STATUS" ] ;then
        HTTP_STATUS="CONNET_ERROR"
fi

case $HTTP_STATUS in
        200)
        echo "OK HTTP $HTTP_STATUS ";
        exit $ST_OK;
        ;;
        500|502|504|CONNET_ERROR)
        echo "CRITICAL $HTTP_STATUS $URL";
        exit $ST_CR;
        ;;
        *)
        echo "WARNING $HTTP_STATUS";
        exit $ST_WR
        ;;
esac
