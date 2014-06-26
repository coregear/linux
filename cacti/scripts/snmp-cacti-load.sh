#!/bin/sh
# 
# snmp-cacti-load.sh
# 
# Autor         : Danny Bendersky <danny@team.inter.net>
# Date          : 11 Feb 2002
# Version       : 1.0
# Description	: Script that give the load in a server with SNMP.
#
#
# Verify that there is an input
# ------------------------------
if [ -z "$1" ]; then
echo "usage: snmp-cacti-load.sh <server> <snmp-comunity> <num>"
echo
exit
fi
#
# Variables
# ---------
SERVER=$1                    # Example: 10.0.0.3
SNMPCOMUNITY=$2              # Example: public
NUM=$3                       # Example: 1
#
case $NUM in
	1)
        /usr/bin/snmpget $SERVER $SNMPCOMUNITY .1.3.6.1.4.1.2021.10.1.3.1 | awk '{print $3}'
        ;;
	5)
        /usr/bin/snmpget $SERVER $SNMPCOMUNITY .1.3.6.1.4.1.2021.10.1.3.2 | awk '{print $3}'
        ;;
	15)
        /usr/bin/snmpget $SERVER $SNMPCOMUNITY .1.3.6.1.4.1.2021.10.1.3.3 | awk '{print $3}'
        ;;
	*)
        /usr/bin/snmpget $SERVER $SNMPCOMUNITY .1.3.6.1.4.1.2021.10.1.3.1 | awk '{print $3}'
        /usr/bin/snmpget $SERVER $SNMPCOMUNITY .1.3.6.1.4.1.2021.10.1.3.2 | awk '{print $3}'
        /usr/bin/snmpget $SERVER $SNMPCOMUNITY .1.3.6.1.4.1.2021.10.1.3.3 | awk '{print $3}'
        ;;
esac
#
# End of File