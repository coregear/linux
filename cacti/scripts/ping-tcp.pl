#!/usr/bin/perl

require 5.002;
use Socket;
use Time::HiRes qw(gettimeofday tv_interval);
use Errno qw(ECONNREFUSED EINTR);

sub timeout
{
        return;
}

sub ping
{
        my($host, $timeout, $count) = @_;
        my $iaddr = inet_aton($host) or die "Unknown host: $host\n";
        my $proto = getprotobyname('tcp') or die "getprotobyname: $!\n";
        my $n = 0;
        my $port = 65535;
        my $paddr = undef;
        my $elapsed = 0;
        my $got = 0;

        while($n++ < $count || !$count)
        {
                $paddr = sockaddr_in($port, $iaddr) or
                        die "getprotobyname: $!\n";

                socket(SOCKET, PF_INET, SOCK_STREAM, $proto) or 
                        die "socket: $!\n";

                local($SIG{'ALRM'}) = 'timeout';
                alarm($timeout);

                my $t0 = [gettimeofday];
                connect(SOCKET, $paddr);

                if ($! == &EINTR)
                {
                        $port--;
                }

                if ($! == &ECONNREFUSED)
                {
                        $got++;
                        $elapsed += tv_interval ($t0, [gettimeofday]);  
                }

                close(SOCKET);
        }

        if ($got)
        {
                return (($elapsed * 1000) / $got);
        }
        else
        {
                return -1;
        }
}

print ping($ARGV[1], 5, $ARGV[0]);