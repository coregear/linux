#!/usr/bin/perl
#
#
#This script fetch the number of online users in a Freeradius server with mysql module.
#You just have to change login, password, databasename and the ip address of your NAS.
#Omar Armas <oarmas at mpsnet.net.mx>

use DBI;

my $dsn = 'DBI:mysql:radius:localhost';
my $db_user_name = 'username';
my $db_password = 'password';
my $dbh = DBI->connect($dsn, $db_user_name, $db_password) or die "Failed to connect $DBI::errstr\n";

my $sth = $dbh->prepare(qq{
    SELECT DISTINCT UserName,AcctStartTime,FramedIPAddress,CallingStationId FROM radacct
	WHERE AcctStopTime = '0' AND NASIPAddress = '200.23.1.1' GROUP BY UserName
    });
$sth->execute();
print $sth->rows();

exit;