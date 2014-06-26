#!/usr/bin/perl 

if (-r '/proc/meminfo') { 
    $procfile = '/proc/meminfo'; 
} elsif (-r '/compat/linux/proc/meminfo') { 
    # FreeBSD Linux emulation 
    $procfile = '/compat/linux/proc/meminfo'; 
} else { 
    # this only works for Linux or FreeBSD (with linux emulation) 
    exit(1); 
} 

open(PROCFILE,$procfile); 
while (<PROCFILE>) { 
    chomp(); 
    if (/^$ARGV[0]/) { 
        s/^$ARGV[0]:?\s+(\d+).*/$1/g; 
        print; 
        last; 
    } 
} 
close(PROCINFO);