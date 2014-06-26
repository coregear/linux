#!/usr/bin/perl
#-----------------------------------------------------------------------------
# HostInfo AWStats plugin
# This plugin allow you to add information on hosts, like a whois fields.
#-----------------------------------------------------------------------------
# Perl Required Modules: XWhois
#-----------------------------------------------------------------------------
# $Revision: 1.12 $ - $Author: eldy $ - $Date: 2004/03/27 18:09:00 $


# <-----
# ENTER HERE THE USE COMMAND FOR ALL REQUIRED PERL MODULES
push @INC, "${DIR}/plugins";
# ----->
use strict;no strict "refs";

require "${DIR}/plugins/qqwry.pl";

#-----------------------------------------------------------------------------
# PLUGIN VARIABLES
#-----------------------------------------------------------------------------
# <-----
# ENTER HERE THE MINIMUM AWSTATS VERSION REQUIRED BY YOUR PLUGIN
# AND THE NAME OF ALL FUNCTIONS THE PLUGIN MANAGE.
my $PluginNeedAWStatsVersion="6.0";
my $PluginHooksFunctions="ShowInfoHost";
# ----->

# <-----
# IF YOUR PLUGIN NEED GLOBAL VARIABLES, THEY MUST BE DECLARED HERE.
use vars qw/
/;
# ----->



#-----------------------------------------------------------------------------
# PLUGIN FUNCTION: Init_pluginname
#-----------------------------------------------------------------------------
sub Init_qqhostinfo {
	my $InitParams=shift;
	my $checkversion=&Check_Plugin_Version($PluginNeedAWStatsVersion);

	# <-----
	# ENTER HERE CODE TO DO INIT PLUGIN ACTIONS
	debug(" InitParams=$InitParams",1);
	# ----->

	return ($checkversion?$checkversion:"$PluginHooksFunctions");
}





#-----------------------------------------------------------------------------
# PLUGIN FUNCTION: ShowInfoHost_pluginname
# UNIQUE: NO (Several plugins using this function can be loaded)
# Function called to add additionnal columns to the Hosts report.
# This function is called when building rows of the report (One call for each
# row). So it allows you to add a column in report, for example with code :
#   print "<TD>This is a new cell for $param</TD>";
# Parameters: Host name or ip
#-----------------------------------------------------------------------------
sub ShowInfoHost_qqhostinfo {
    my $param="$_[0]";
	# <-----
	if ($param eq '__title__') {
		print "<th width=\"80\">Location</th>";	
	}
	elsif ($param) {
		print "<td>";
		print ipwhere("$param");
		#print $param;
		print "</td>";
	}
	else {
		print "<td>&nbsp;</td>";
	}
	return 1;
	# ----->
}




1;	# Do not remove this line
