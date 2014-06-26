#!/usr/bin/perl

# bind-stats.pl - a script to return bind-related statistical information
#                 Author: Matt Groener, gwynnebaer@hotmail.com

# Use built-in option syntax
use Getopt::Std;

# use $opt_d to override default named.stats dir location
getopt('d');

$STATFILE = $opt_d ? "$opt_d/named.stats" : '/var/named/named.stats';
$MEMFILE  = $opt_d ? "$opt_d/named.memstats" : '/var/named/named.memstats';
$cmd_ndc  = '/usr/sbin/ndc -q stats > /dev/null 2>&1';

# Generate stats now (this could be turned off and run via cron as well)
unlink($STATFILE,$MEMFILE);
qx($cmd_ndc);
$status = $?;
die "Failed command: $cmd_ndc: EXIT_CODE: $status" if $status;

# Die unless we can locate the stats file
if (!open(STATS,$STATFILE)) {
        die "Failed to open $STATFILE: $!\n";
}

# Parse the stats file
while (<STATS>) {
        next if /^[\-\+]/;
        chomp();
        if (/Legend/) { $start_legend++; next; }
        if (/Global/) { $start_legend--; $start_global++; next; }
        if ($start_legend) {
                push(@legend,split());
        } elsif ($start_global) {
                @global = split();
                for (0..$#legend) { $hash{lc($legend[$_])} = $global[$_]; }
                last;
        } else {
                @data = split();
                next if $data[1] =~ /^\d+$/;
                # break up the data and build hash of data
                /time since/i && do { $hash{lc($data[3])} = $data[0]; next; };
                /^\d+\s+.*\s+quer/i && do { $hash{lc($data[1])} = $data[0]; next; };
        }
}
close (STATS);

# print out stats or usage
if (@ARGV) {
        foreach $argv (@ARGV) {
                push(@output,$hash{lc($argv)}) if defined $hash{lc($argv)};
        }
        print "@output";
} else {
        print "Usage: $0 [-d statsdir] args\n\n       where args is one of:\n       ";
        foreach $argv (sort keys %hash) {
                print $argv;
                $incr++;
                if ($incr == 13) {
                        print "\n       ";
                        $incr = 0;
                } else {
                        print " ";
                }
        }
        print "\n\n";
}