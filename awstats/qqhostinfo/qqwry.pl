#####################################################
#  LEO SuperCool BBS / LeoBBS X / 雷傲极酷超级论坛  #
#####################################################
# 基于山鹰(糊)、花无缺制作的 LB5000 XP 2.30 免费版  #
#   新版程序制作 & 版权所有: 雷傲科技 (C)(R)2004    #
#####################################################
#      主页地址： http://www.LeoBBS.com/            #
#      论坛地址： http://bbs.LeoBBS.com/            #
#####################################################

sub ipwhere {
	my $ipbegin,$ipend,$ipData1,$ipData2,$DataSeek,$ipFlag;
	
	my $ip=shift;
	my @ip=split(/\./,$ip);
	my $ipNum = $ip[0]*16777216+$ip[1]*65536+$ip[2]*256+$ip[3];

	#my $ipfile="./QQWry.Dat";
	my $ipfile="${DIR}/plugins/QQWry.Dat";
	open(FILE,"$ipfile");
	binmode(FILE);
	sysread(FILE,$ipbegin,4);
	sysread(FILE,$ipend,4);
	 $ipbegin=unpack("L",$ipbegin);
	 $ipend=unpack("L",$ipend);
	my $ipAllNum = ($ipend-$ipbegin)/7+1;

	my $BeginNum=0;
	my $EndNum=$ipAllNum;

	Bgn:
	my $Middle= int(($EndNum+$BeginNum)/2);

	seek(FILE,$ipbegin+7*$Middle,0);
	read(FILE,$ipData1,4);
	my $ip1num=unpack("L",$ipData1);
	if ($ip1num > $ipNum) {
		$EndNum=$Middle;
		goto Bgn;
	}

	read(FILE,$DataSeek,3);
	$DataSeek=unpack("L",$DataSeek."\0");
	seek(FILE,$DataSeek,0);
	read(FILE,$ipData2,4);
	my $ip2num=unpack("L",$ipData2);
	if ($ip2num < $ipNum) {
		goto nd if ($Middle==$BeginNum);
		$BeginNum=$Middle;
		goto Bgn;
	}

	$/="\0";
	read(FILE,$ipFlag,1);
	if ($ipFlag eq "\1") {
		my $ipSeek;
		read(FILE,$ipSeek,3);
		$ipSeek = unpack("L",$ipSeek."\0");
		seek(FILE,$ipSeek,0);
		read(FILE,$ipFlag,1);
	}
	if ($ipFlag eq "\2") {
		my $AddrSeek;
		read(FILE,$AddrSeek,3);
		read(FILE,$ipFlag,1);
		if($ipFlag eq "\2") {
			my $AddrSeek2;
			read(FILE,$AddrSeek2,3);
			$AddrSeek2 = unpack("L",$AddrSeek2."\0");
			seek(FILE,$AddrSeek2,0);
		}
		else {
			seek(FILE,-1,1);
		}
		$ipAddr2=<FILE>;
		$AddrSeek = unpack("L",$AddrSeek."\0");
		seek(FILE,$AddrSeek,0);
		$ipAddr1=<FILE>;
	}
	else {
		seek(FILE,-1,1);
		$ipAddr1=<FILE>;
		read(FILE,$ipFlag,1);
		if($ipFlag eq "\2") {
			my $AddrSeek2;
			read(FILE,$AddrSeek2,3);
			$AddrSeek2 = unpack("L",$AddrSeek2."\0");
			seek(FILE,$AddrSeek2,0);
		}
		else {
			seek(FILE,-1,1);
		}
		$ipAddr2=<FILE>;
	}

	nd:
	chomp($ipAddr1,$ipAddr2);
	$/="\n";
	close(FILE);
	
	$ipAddr2="" if($ipAddr2=~/http/i);
	my $ipaddr="$ipAddr1 $ipAddr2";
	$ipaddr =~ s/CZ88\.NET//isg;
	$ipaddr="未知地区" if ($ipaddr=~/未知|http/i || $ipaddr eq "");
	return $ipaddr;
}

sub osinfo {
   local $os="",$Agent;
   $Agent = $ENV{'HTTP_USER_AGENT'};
   if (($Agent =~ /win/i)&&($Agent =~ /95/i)) {
      $os="Windows 95";
   }
   elsif (($Agent =~ /win 9x/i)&&($Agent =~ /4.90/i)) {
      $os="Windows ME";
   }
   elsif (($Agent =~ /win/i)&&($Agent =~ /98/i)) {
      $os="Windows 98";
   }
   elsif (($Agent =~ /win/i)&&($Agent =~ /nt 5\.0/i)) {
      $os="Windows 2000";
   }
   elsif (($Agent =~ /win/i)&&($Agent =~ /nt 5\.1/i)) {
      $os="Windows XP";
   }
   elsif (($Agent =~ /win/i)&&($Agent =~ /nt 5\.2/i)) {
      $os="Windows 2003";
   }
   elsif (($Agent =~ /win/i)&&($Agent =~ /nt/i)) {
      $os="Windows NT";
   }
   elsif (($Agent =~ /win/i)&&($Agent =~ /32/i)) {
      $os="Windows 32";
   }
   elsif ($Agent =~ /linux/i) {
      $os="Linux";
   }
   elsif ($Agent =~ /unix/i) {
      $os="Unix";
   }
   elsif (($Agent =~ /sun/i)&&($Agent =~ /os/i)) {
      $os="SunOS";
   }
   elsif (($Agent =~ /ibm/isg)&&($Agent =~ /os/isg)) {
      $os="IBM OS/2";
   }
   elsif (($Agent =~ /Mac/i)&&($Agent =~ /PC/i)) {
      $os="Macintosh";
   }
   elsif ($Agent =~ /FreeBSD/i) {
      $os="FreeBSD";
   }
   elsif ($Agent =~ /PowerPC/i) {
      $os="PowerPC";
   }
   elsif ($Agent =~ /AIX/i) {
      $os="AIX";
   }
   elsif ($Agent =~ /HPUX/i) {
      $os="HPUX";
   }
   elsif ($Agent =~ /NetBSD/i) {
      $os="NetBSD";
   }
   elsif ($Agent =~ /BSD/i) {
      $os="BSD";
   }
   elsif ($Agent =~ /OSF1/i) {
      $os="OSF1";
   }
   elsif ($Agent =~ /IRIX/i) {
      $os="IRIX";
   }
   elsif ($Agent =~ /google/i) {
      $os = "GoogleBot";
   }
   elsif ($Agent =~ /Yahoo/i) {
      $os = "YahooBot";
   }
  $os = "Unknown"  if ($os eq '');
  $os =~ s/[\a\f\n\e\0\r\t\)\(\*\+\?]//isg;
  $os = substr($os, 0, 15) if (length($os) > 15);
  return $os;
}
sub browseinfo {
       my $browser = "";
       my $browserver = "";
       my ($Agent, $Part, $browseinfo);
       $Agent = $ENV{"HTTP_USER_AGENT"};

       if ($Agent =~ /Lynx/i)
       {
               $browser = "Lynx";
       }
       elsif ($Agent =~ /MOSAIC/i)
       {
               $browser = "MOSAIC";
       }
       elsif ($Agent =~ /AOL/i)
       {
               $browser = "AOL";
       }
       elsif ($Agent =~ /Lynx/i)
       {
               $browser = "Lynx";
       }
       elsif ($Agent =~ /Opera/i)
       {
               $browser = "Opera";
       }
       elsif ($Agent =~ /JAVA/i)
       {
               $browser = "JAVA";
       }
       elsif ($Agent =~ /MacWeb/i)
       {
               $browser = "MacWeb";
       }
       elsif ($Agent =~ /WebExplorer/i)
       {
               $browser = "WebExplorer";
       }
       elsif ($Agent =~ /OmniWeb/i)
       {
               $browser = "OmniWeb";
       }
       elsif ($Agent =~ /Mozilla/i)
       {
               if ($Agent =~ "MSIE")
               {
                       if ($Agent =~ /MyIE(\d*)/)
                       {
                               $browserver = $1;
                               $browser = "MyIE";
                       }
                       else
                       {
                               $Part = (split(/\(/, $Agent))[1];
                               $Part = (split(/\;/,$Part))[1];
                               $browserver = (split(/ /,$Part))[2];
                               $browserver =~ s/([\d\.]+)/$1/isg;
                               $browser = "Internet Explorer";
                       }
               }
               elsif ($Agent =~ "Opera")
               {
                       $Part = (split(/\(/, $Agent))[1];
                       $browserver = (split(/\)/, $Part))[1];
                       $browserver = (split(/ /,$browserver))[2];
                       $browserver =~ s/([\d\.]+)/$1/isg;
                       $browser = "Opera";
               }
               else
               {
                       $Part = (split(/\(/, $Agent))[0];
                       $browserver = (split(/\//, $Part))[1];
                       $browserver = (split(/ /,$browserver))[0];
                       $browserver =~ s/([\d\.]+)/$1/isg;
                       $browser = "Netscape Navigator";
               }
       }
       elsif ($Agent =~ /google/i)
       {
               $browser = "GoogleBot";
       }
       elsif ($Agent =~ /Yahoo/i)
       {
               $browser = "YahooBot";
       }

       if ($browser ne '')
       {
               $browserver =~ s/[^0-9\.b]//isg;
               $browserver = &lbhz($browserver, 4) if (length($browserver) > 10);
               $browseinfo = "$browser $browserver";
       }
       else
       {
               $browseinfo = "Unknown";
       }
       $browseinfo =~ s/[\a\f\n\e\0\r\t\)\(\*\+\?]//isg;
  $browseinfo =~ s/[\a\f\n\e\0\r\t\)\(\*\+\?]//isg;
  $browseinfo = substr($browseinfo, 0, 28) if (length($browseinfo) > 28);
       return $browseinfo;
}
1;
