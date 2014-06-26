#!/usr/bin/perl -w
#
# It is my first (dirty) perl script. GPL2.
# It use echoping to test responce time of servers for http, https, smtp and echo protocols
# 07/08/2002 version 0.2
# Please e-mail me optimisations...
# Sébastien Desse : sdesse@euresys.fr
#
# sysntax : echoping.pl <number of tests> <protocol> <URL>
#       number of tests         > 1
#       protocol                = http | ssl | smtp | echo
#       URL                     = @IP | FQDN
#
#

@ARGV == 3 or die "Syntax : echoping.pl <number of tests> <protocol> <URL>\n";


if (($ARGV[0] =~ m/^\d+$/) and ($ARGV[0] > 1) and  ($ARGV[0] < 11)) {
        $NumberOfTests = "-n $ARGV[0]";
} else {
        $NumberOfTests = "-n 5";
}

if ($ARGV[1] =~ m/http/i) {
        $Protocol = "-h /";
# Need echoping compiled with SSL support
#} elsif ($ARGV[1] =~ m/ssl/i) {
#       $Protocol = "-C -h /";
} elsif ($ARGV[1] =~ m/smtp/i) {
        $Protocol = "-S";
} elsif ($ARGV[1] =~ m/echo/i) {
        $Protocol = "";
} else {
        $Protocol = "-h /";
}       

$Url = $ARGV[2];

($Min,$Max,$Average) = (`echoping $NumberOfTests $Protocol $Url` =~ m/Min.*(\d+\.\d+).*\nMax.*(\d+\.\d+).*\nAverage.*(\d+\.\d+)/);

print "$Min $Max $Average";