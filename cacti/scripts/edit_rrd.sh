#!/bin/bash

if [ $# = 0 ]
then
        echo "Usage ./edit_rrd.sh [FILENAME]"
        exit
fi

rrdtool dump $1 > /tmp/work.xml

vi /tmp/work.xml

rm -f $1

rrdtool restore /tmp/work.xml $1