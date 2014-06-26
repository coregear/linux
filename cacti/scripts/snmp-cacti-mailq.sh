#!/bin/sh
# 
# snmp-cacti-mailq.sh
# 
# Autor         : Danny Bendersky <danny@team.inter.net>
# Date          : 12 Feb 2002
# Version       : 1.0
# Description	: Script that give the mailq in a server with SNMP
#
#
# Verify that there is an input
# ------------------------------
if [ -z "$1" ]; then
echo "usage: snmp-cacti-mailq.sh <server> <snmp-comunity>"
echo
exit
fi
#
# Variables
# ---------
SERVER=$1                    # Example: 10.0.0.3
SNMPCOMUNITY=$2              # Example: public
#
/usr/bin/snmpwalk -v 1 $SERVER $SNMPCOMUNITY .1.3.6.1.4.1.2021.53.101.0\
| awk '{ print $5 }'|sed -e "s/(//g"
#
#
# End of File