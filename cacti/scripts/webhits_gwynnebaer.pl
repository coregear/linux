#!/usr/bin/perl 

# reads in apache (or any) logfile and returns either 0 or number of lines 
$lines = 0; 

unless ($ARGV[0]) { 
        $log_path = '/var/log/httpd/access_log'; 
} else { 
        $log_path = $ARGV[0]; 
} 


if (-r $log_path) { 
        open(LOG_PATH,$log_path); 
        while (<LOG_PATH>) { 
                $lines++; 
        } 
        close(LOG_PATH); 
} 

print $lines;