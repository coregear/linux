#!/usr/bin/perl

##FreeBSD Stats Grabber



##### Set MySql Login/Password #####

$msqluser = "root";
$msqlpass = "rootpassword";

##### Set Paths ######

$shell = '/usr/local/bin/bash'; 		### Path to bash or csh
$grep = '/usr/bin/grep';			### Path to grep
$uptime = '/usr/bin/uptime';			### Path to uptime
$mysqladmin = '/usr/local/bin/mysqladmin';	### Path to mysqladmin
$top = '/usr/bin/top';				### Path to top
$wc = '/usr/bin/wc';				### Path to wc
$w = '/usr/bin/w';				### Path to w
$users = '/usr/bin/users';			### Path to users
$netstat = '/usr/bin/netstat';			### Path to netstat
$df = '/bin/df';				### Path to df
$lynx = '/usr/local/bin/lynx';			### Path to lynx
$ping = '/sbin/ping';				### Path to ping
$cat = '/bin/cat';				### Path to cat
$compat_meminfo = '/compat/linux/proc/meminfo';	### Path to meminfo (if freebsd, you need linux compatablity)
$compat_uptime = '/compat/linux/proc/uptime';   ### Path to uptime (this is to the linux uptime file, not the /usr/bin/uptime, 
i did this to save prossesing time)


#########################################################
#            DONT TOUCH BELOW THIS LINE                 #
#   You will have to change the URLS in some locations  #
#########################################################

$shell .= ' -c';
$cmd_argv0 = $ARGV[0];
$cmd_argv1 = $ARGV[1];
$data_input = "";
$data = "";
$data1 = "";
@data3 = "";
$help = "";

if ($cmd_argv0 eq "load") {
	$data_input = `$shell '$uptime'`;
	$data_input =~ s/.*://;
	$data_input =~ s/,//gi;
	$data_input =~ s/^ //;
	chomp $data_input;
	print $data_input;
} 
elsif ($cmd_argv0 eq "temp") {
	#5/9*(F-32)=C
	$data_input = `$shell 'lynx -dump 'http://www.weather.com/weather/local/NOXX0032?letter=S' | grep "Feels Like"'`;
	$data_input =~ s/[a-zA-Z\:\ ]//g;
	$data_input =~ s/\?/ /g;
	chomp ($data_input); chop ($data_input);
	@data3 = split(/ /, $data_input);
	$data1 = (5/9)*($data3[0]-32);
	$data2 = (5/9)*($data3[1]-32);
	print "$data1 $data2";
}
elsif ($cmd_argv0 eq "cpustats") {
	# user nice system interrupt idel
	$data_input = `$shell '$top -d2 -s1 | $grep "states:"'`;
	$data_input =~ s/[a-zA-Z\,\:\ ]//g;
	$data_input =~ s/\%/ /g;
	chomp($data_input);
	chop($data_input);
	print $data_input;
}
elsif ($cmd_argv0 eq "users") {
	$data_input = `$shell '$w | $wc -l'`;
	$data_input =~ /([\d]+)/;
	$data1 = $1-2;
	$data_input = `$shell '$users | $wc -w'`;
	$data_input =~ /([\d]+)/;
	$data = $1;
	print "$data $data1";
}
elsif ($cmd_argv0 eq "mysql_query") {
	$data_input = `$shell '$mysqladmin -u$msqluser -p$msqlpass status'`;
	$data_input=~ /Queries per second avg: (\d.\d+)/;
	print $1;
}
elsif ($cmd_argv0 eq "mysql_threads") {
	$data_input = `$shell '$mysqladmin -u$msqluser -p$msqlpass status'`;
	$data_input=~ /Threads: (\d+)/;
	print $1;
}
elsif ($cmd_argv0 eq "mysql_slow") {
	$data_input = `$shell '$mysqladmin -u$msqluser -p$msqlpass status'`;
	$data_input=~ /Slow queries: (\d+)/;
	print $1;
}
elsif ($cmd_argv0 eq "mysql_opens") {
	$data_input = `$shell '$mysqladmin -u$msqluser -p$msqlpass status'`;
	$data_input=~ /Opens: (\d+)/;
	print $1;
}
elsif ($cmd_argv0 eq "mysql_questions") {
	$data_input = `$shell '$mysqladmin -u$msqluser -p$msqlpass status'`;
	$data_input=~ /Questions: (\d+)/;
	print $1;
}
elsif ($cmd_argv0 eq "procs") {
	$data_input = `$shell '$top -s1 -d1 | $grep processes'`;
	$data_input =~ /running\, *(\d+)/;
	$data = $1;
	$data_input =~ /processes\: *(\d+)/;
	$data1 = $1;
	print "$data1 $data";
}
elsif ($cmd_argv0 eq "uptime") {
	$data_input = `$shell '$cat $compat_uptime'`;
	$data_input =~ /(\d+).*/;
	$data = $1;
	$data = ($data/60);
	$data = ($data/60);
	print "$data";
}
elsif ($cmd_argv0 eq "harddrive") {
	$data_input = `$shell '$df -k | $grep $cmd_argv1'`;
	$data_input =~ /^[\/0-9a-zA-Z]+ *(\d+) *(\d+)/;
	$data = $1;
	$data1 = $2;
	$data *= 1000;
	$data1 *= 1000;
	print "$data $data1";
}
elsif ($cmd_argv0 eq "mem") {
	$data_input = `$shell '$cat $compat_meminfo | $grep Mem'`;
	$data_input =~ /^Mem: *(\d+) *(\d+)/;
	print "$1 $2";
} 
elsif ($cmd_argv0 eq "cache") {
	$data_input = `$shell '$cat $compat_meminfo | $grep Mem'`;
	$data_input =~ /Mem: *(\d+) *(\d+) *(\d+) *(\d+) *(\d+) *(\d+)/;
	print $6;    
} 
elsif ($cmd_argv0 eq "swap") {
	$data_input = `$shell '$cat $compat_meminfo | $grep Swap'`;
	$data_input =~ /Swap: *(\d+) *(\d+) *(\d+)/;
	print "$1 $2";
}
elsif ($cmd_argv0 eq "apache_bytes") {
	$data_input = `$shell '$lynx -dump http://www.CHANGEME.com/server-status?auto | $grep kBytes'`;
	$data_input =~ /.*Total kBytes.*: (\d+).*/;
	$data = $1;
	$data *= 1024;
	print $data;
}
elsif ($cmd_argv0 eq "apache_access") {
	$data_input = `$shell '$lynx -dump http://www.CHANGEME.com/server-status?auto | $grep Accesses'`;
	$data_input =~ /.*Total Accesses.*: (\d+).*/;
	print $1;
}
elsif ($cmd_argv0 eq "apache_uptime") {
	$data_input = `$shell '$lynx -dump http://www.CHANGEME.com/server-status?auto | $grep Uptime'`;
	$data_input =~ /.*Uptime.*: (\d+).*/;
	$data = $1;
	$data = ($data/60);
	$data = ($data/60);
	print $data;
}
elsif ($cmd_argv0 eq "apache_servers") {
	$data_input = `$shell '$lynx -dump http://www.CHANGEME.com/server-status?auto | $grep BusyServers'`;
	$data_input =~ /BusyServers.*: (\d+)/;
	$data = $1;
	$data_input = `$shell '$lynx -dump http://www.CHANGEME.com/server-status?auto | $grep IdleServers'`;
	$data_input =~ /IdleServers.*: (\d+)/;
	print "$data $1";
}
elsif ($cmd_argv0 eq "tcpopen") {
	$data_input = `$shell '$netstat -tn | $grep ESTABLISHED | $wc -l'`;
	$data_input =~ /(\d+)/;
	print $1;
}
elsif ($cmd_argv0 eq "ftpopen") {
	$data_input = `$shell '$netstat -tn | $grep ".21 .*ESTABLISHED" | $wc -l'`;
	$data_input =~ /(\d+)/;
	print $1;
}
elsif ($cmd_argv0 eq "httpopen") {
	$data_input = `$shell '$netstat -tn | $grep ".80 .*ESTABLISHED" | $wc -l'`;
	$data_input =~ /(\d+)/;
	print $1;
}
elsif ($cmd_argv0 eq "netbiosopen") {
	$data_input = `$shell '$netstat -tn | $grep ".139 .*ESTABLISHED" | $wc -l'`;
	$data_input =~ /(\d+)/;
	print $1;
}
elsif ($cmd_argv0 eq "customopen") {
        $data_input = `$shell '$netstat -tn | $grep "\.$cmd_argv1 .*ESTABLISHED" | $wc -l'`;
        $data_input =~ /(\d+)/;
        print $1;
}
elsif ($cmd_argv0 eq "ping") {
	$data_input = `$shell '$ping -c 3 $cmd_argv1 | $grep round-trip'`;
	$data_input =~ /^round-trip.+\/([\d.]+)\/([\d.]+)\//;
	print "$1 $2";
} 
else {
	$help  = "FreeBSD Stats Grabber (written by Ross) for Cacti 0.6.6+ (written by Ian Berry).\n\n";
	$help .= "Usage: stat.pl <option> [argv]\n";
	$help .= "Apache Options:\n";
	$help .= "\tapache_bytes\tapache_access\tapache_uptime\n\tapache_servers\n\n";
	$help .= "System Options:\n";
	$help .= "\tcache\tcpustats\tload\tusers\n\tprocs\tuptime\tswap\tmem\n\tharddrive [hdd name ie. (da1s1e)]\n\n";
	$help .= "Network Options:\n";
	$help .= "\ttcpopen\t\tftpopen\thttpopen\n\tnetbiosopen\tping\tcustomopen [port number]\n\n";
	$help .= "Mysql Options:\n";
	$help .= "\tmysql_query\tmysql_threads\tmysql_slow\n\tmysql_opens\tmysql_questions\n";
	print "$help";
}