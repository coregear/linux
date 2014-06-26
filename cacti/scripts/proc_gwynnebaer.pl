#!/usr/bin/perl 

# returns number of open processes from 'ps' output 

open(PROCS,'/bin/ps ax |'); 
while (<PROCS>) { 
        $procs++; 
} 
close(PROCS); 

$procs--; 

print $procs;