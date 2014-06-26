#!/usr/bin/perl 

# get load uptimes for 1;5;15 min 
# usage: loadavg.pl 1|5|15|all|debug 
chomp($uptime = qx(uptime)); 
$uptime_raw = $uptime; 
$uptime =~ s/.*:\s+|,//g; 
@uptime = split(/\s+/,$uptime); 

for ($ARGV[0]) { 
        /^1$/ && print $uptime[0]; 
        /^5/ && print $uptime[1]; 
        /^15/ && print $uptime[2]; 
        /all/ && print $uptime; 
        /debug/ && do { print "UPTIME: $uptime_raw\n", 
                              "5MIN:    $uptime[0]\n", 
                              "15MIN:   $uptime[1]\n", 
                              "30MIN:   $uptime[2]\n"; }; 
} 

exit 0;