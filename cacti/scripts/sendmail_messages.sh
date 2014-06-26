#!/bin/bash
#
# Autor         : Stefan Arts, Holland
# Date          : 07/22/05
# Version       : 1.0
# Description   : Script to output the number of messages send to sendmail
#                 Output is <messages received by sendmail>
#
#                 If you run the cacti poller as non-root, then you may need
#                 need to change the permissions of the sendmail statistics
#                 file. Example:
#
#                   chmod 644 /etc/mail/statistics
#
/usr/sbin/mailstats | grep ^\ T | cut -b25-32 | sed s/\ *//