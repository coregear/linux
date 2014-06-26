#!/usr/bin/perl

if (! eval "require LWP::UserAgent;")
{
	$ret = "LWP::UserAgent not found";
}

if ( exists $ARGV[0]) {
	if ($ret)
	{
		print "no ($ret)\n";
		exit 1;
	}

	my $ua = LWP::UserAgent->new(timeout => 5);

	my $response = $ua->request(HTTP::Request->new('GET',$ARGV[0]));
	my @content = split (/\n/, $response->content);

	my $active_connections = -1;
	if ($content[0] =~ /^Active connections:\s+(\d+)\s*$/i) {
		$active_connections = $1;
	}

	my $accepts = -1;
	my $handled = -1;
	my $requests = -1;
	if ($content[2] =~ /^\s+(\d+)\s+(\d+)\s+(\d+)\s*$/) {
		$accepts = $1;
		$handled = $2;
		$requests = $3;
	}

	my $reading = -1; 
	my $writing = -1; 
	my $waiting = -1;
	if ($content[3] =~ /Reading: (\d+) Writing: (\d+) Waiting: (\d+)\s*$/) {
		$reading = $1;
		$writing = $2;
		$waiting = $3;
	}

	print "nginx_active:$active_connections nginx_reading:$reading nginx_writing:$writing nginx_waiting:$waiting ";
	print "\n";
}


