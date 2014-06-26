#!/usr/bin/perl
#
# This is a quick perl script to 
# pull bandwidth usage from iptables chains
#
# If you use/optimize this script, please let me know.
# Brian Stanback : brian [at] stanback [dot] net

# Example iptables rule for web bandwidth usage:
# > iptables -N WWW
# > iptables -A WWW -j ACCEPT
# > iptables -A INPUT -p tcp -m tcp --dport 80 -j WWW
# > iptables -A OUTPUT -p tcp -m tcp --sport 80 -j WWW
#
# Run "iptables.pl WWW" as root to test, note that you can 
# combine more than one protocol into a single chain.
#
# Sudo Configuration (/etc/sudoers)
# > www-data    ALL = NOPASSWD: /usr/share/cacti/scripts/iptables.pl
#
# The Input String should be set to "sudo <path_cacti>/scripts/iptables.pl <chain>"
# and you will need to setup an input field so that the <chain> argument can be passwd.
#
# The data input type should be set to COUNTER
#

if ($ARGV[0])
{
        $chains = `/sbin/iptables -xnvL | grep -A 2 'Chain $ARGV[0]'`;
        @chains = split(/\n/, $chains);
        $chains[2] =~ /[\W+]?[0-9]+\W+([0-9]+)\W+/;
        print $1;
}
else
{
        print "Usage: $0 Chain\n";
}