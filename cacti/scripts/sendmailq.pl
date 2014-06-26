#!/usr/bin/perl
# sendmailq.pl
#
# Autor         : Jeremy Garcia <jeremy@linuxquestions.org>
# Date          : 05/03/02
# Version       : 0.2
#		: - Added support for both single and multiple queues
#		: - Tried to accomodate for as many different forms of output as possible.
#		    If I missed yours let me know and I will include it.
# Description	: Script to output the number of messages in a sendmail queue.
#		  Output is <messages in queue>

# If you run sendmail with mupltiple queues uncomment this line
#$MULTIPLE_QUEUE = 1;

if ($MULTIPLE_QUEUE) {
	$mailq = `mailq | grep "Total Requests:" | cut -d' ' -f3`;
	chomp $mailq;
}
else {
	$mailq = `mailq | head -1 | cut -d'(' -f2 | cut -d' ' -f01`;
	chomp $mailq;
	if ($mailq eq "is" || $mailq =~ "queue" || $mailq eq "Mail") { $mailq = 0 }
}

print $mailq;