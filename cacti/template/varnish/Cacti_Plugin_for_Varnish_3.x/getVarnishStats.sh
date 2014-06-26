#!/bin/bash

host=$1
com=$2
OID=".1.3.6.1.4.1.8072.1.3.2.3.1.1.12.118.97.114.110.105.115.104.115.116.97.116.115"

# For SNMP V2
resultados=`snmpwalk -t 20 -Oqv -v 2c -c $com $host $OID | awk '{ printf("%s", $0) }'`

# For SNMP V3  -u username  -A password
#resultados=`snmpwalk -v3 -u cactiuser -l auth -a MD5 -A cactiuser $host $OID | awk '{ printf("%s", $0) }'`

echo -n $resultados