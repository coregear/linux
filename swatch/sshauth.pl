#!/usr/bin/perl -w
#
#############################################################################
#
# File: sshauth.pl
#
# Purpose: To interface with psad to block IP addresses that commit failed
#          login attempts against SSHD.  This script was written for the
#          book "Linux Firewalls: Attack Detection and Response with
#          iptables, psad, and fwsnort".
#
# Copyright (C) 2006-2007 Michael Rash (mbr@cipherdyne.org)
#
# License (GNU Public License):
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
#   USA
#
#
#############################################################################
#
# $Id: index.html 2980 2011-01-09 15:27:41Z mbr $
#

use IO::Socket;
use IO::Handle;
use strict;

#============== config ===============
my $auth_failed_threshold = 2;
my $auth_failed_regex =
    'sshd.*Authentication\s*failure.*?((?:[0-2]?\d{1,2}\.){3}[0-2]?\d{1,2})';
my $sockfile = '/var/run/psad/auto_ipt.sock';
my $sleep_interval = 5;  ### seconds
#============ end config =============

### cache previously seen IP addresses and associated failed login
### counts
my %ip_cache = ();

### open the psad domain socket for writing
my $psad_sock = IO::Socket::UNIX->new($sockfile)
    or die "[*] Could not acquire psad domain ",
        "socket $sockfile: $!";

my $file = $ARGV[0] or die "$0 <file>";

### open the log file
open F, $file or die "[*] Could not open $file: $!";
my $skip_first_loop = 0;
for (;;) {
    unless ($skip_first_loop) {
        seek F,0,2; ### seek to the end of the file
            $skip_first_loop = 1;
    }
    my @messages = <F>;
    for my $msg (@messages) {
        if ($msg =~ m|$auth_failed_regex|) {
            $ip_cache{$1}++;
        }
    }
    for my $src (keys %ip_cache) {
        ### block the IP if the threshold is exceeded
        if ($ip_cache{$src} % $auth_failed_threshold == 0) {
            print $psad_sock "add $src\n";
        }
    }
    F->clearerr();  ### be ready for new data
    sleep $sleep_interval;
}
close F;
close $psad_sock;
exit 0;