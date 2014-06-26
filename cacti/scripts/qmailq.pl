#!/usr/bin/perl
#
# qmailq.pl
#
# Author         : Jeremy Garcia <jeremy@linuxquestions.org>
# Date          : 07/07/04
# Version       : 0.2
# Description   : Script to output the number of messages in a qmail queue.
#                 Output is <messages in queue> <messages in queue but not yet
#                 preprocessed>
#		  Thanks to Nick, who alerted me to the fact that the script
#		  needed an update
#		  to be compatible with the latest version of cacti.

# Full path to qmail-stat.  If you are using Linux you will need to write
# a SUID perl wrapper as suid sh scripts are no good in Linux.
@queue = `/var/qmail/bin/qmail-qstat.pl`;

@jqueue = split " ",$queue[0];
@pro    = split " ",$queue[1];

print join(':','messages',$jqueue[3])," ",join(':','unprocessed',$pro[7]);