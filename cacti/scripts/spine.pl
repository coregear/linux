#!/usr/bin/perl -w
# Program:      spine.pl
# Description:   Subtituto del cmd.php incluido en el CACTI
#            quien es el que se encarga de colectar los
#            datos via SNMP para actualizar las graficas RRD.
# Version:      0.2 (17/Aug/2002)
# Autor:      Roberto Carlos Navas <rcnavas@telemovil.com>

# Perl Modules to be used.
use DBI;
use Net::SNMP;
use RRDs;
use Sys::Syslog;

# Configuration parameters
%config = (   'debug'         => 1,         # Need debugging info? 0=No 1=Yes
         'syslog_facility'   => 'local4',      # Syslog facility to send
logging
         'MYSQL_HOST'      => 'localhost',   # MySQL server where CACTI
Database is
         'MYSQL_DB'      => 'cacti',      # MySQL cacti database
         'MYSQL_USER'      => 'root',      # MySQL username
         'MYSQL_PASS'      => 'mysqldba',      # MySQL password
         'snmp_timeout'      => 5,         # How many seconds to wait for a
SNMP response
         'snmp_retries'      => 2,         # How many times to retry SNMP get
         'snmp_version'      => 1,         # SNMP protocol version to use
);

# SNMP Numeric OIDs for getting Interface Octects Counters
%oidOctets = (   'in'      => ".1.3.6.1.2.1.2.2.1.10",
            'out'      => ".1.3.6.1.2.1.2.2.1.16",
            'hcin'      => ".1.3.6.1.2.1.2.2.1.10",
            'hcout'      => ".1.3.6.1.2.1.2.2.1.16"
);

# You should not touch the code below this line...
# MAIN program starts here...

printlog('debug', "STARTING spine.pl " . localtime());
$dbh   = DBI->connect(   'dbi:mysql:host=' . $config{'MYSQL_HOST'} .
';database=' . $config{'MYSQL_DB'},
                  $config{'MYSQL_USER'},
                  $config{'MYSQL_PASS'}   ) or do {
                                          printlog('err', "ERROR: Could not
connect to MySQL server! (" . $DBI::errstr . ")");
                                          exit 1;
                                          };

get_cacti_config();

$sql   = "SELECT d.id, d.name, d.srcid, s.formatstrin, s.formatstrout, s.id as
sid, s.type
         FROM rrd_ds d LEFT JOIN src s ON d.srcid=s.id
         WHERE
         d.active = 'on' AND
         d.subdsid= 0";
$sth1   = $dbh->prepare($sql);
$sth1->execute() or do {
                  printlog('err', "ERROR: Could not execute SQL! Error: " .
$dbh->errstr);
                  exit 1;
                  };
while ($sql_id = $sth1->fetchrow_hashref()) {
   printlog('debug', "Processing Data Source: " . $sql_id->{name});
   $sql   = "SELECT d.fieldid, d.dsid, d.value, f.srcid, f.dataname
            FROM src_data d LEFT JOIN src_fields f ON d.fieldid=f.id
            WHERE
            d.dsid  =" . $sql_id->{id} . " and
            f.srcid =" . $sql_id->{srcid};
   $sth2   = $dbh->prepare($sql);
   $sth2->execute() or do {
                     printlog('err', "ERROR: Could Not execute SQL! Error: " .
$dbh->errstr);
                     exit 1;
                     };
   while ($sql_id_field = $sth2->fetchrow_hashref()) {
      printlog('debug', " DS Field: " . $sql_id_field->{dataname} . " Value: "
. $sql_id_field->{value});
      $sql_id_field_value{$sql_id_field->{dataname}} = $sql_id_field->{value};
   }
   if ($sql_id->{type} eq '') {
      # We have to fork a external program...
      # Not implemented Yet...
      printlog('debug', "Datasource " . $sql_id->{name} . "Needs to fork a
program... not implemented yet!");
      next;
   }
   # It's an internal SNMP function...
   # It shouldn't be a multi data source, so only one output parameter is
   # expected...
   if ($sql_id->{formatstrout} =~ /<(\S+)>/i) {
      $out_field   = $1;
   } else {
      printlog('err', "ERROR: formatstrout = " . $sql_id->{formatstrout} . "
is not valid!");
      next;
   }
   ($snmp, $error) = Net::SNMP->session(
                              -hostname      => $sql_id_field_value{"ip"},
                              -community      =>
$sql_id_field_value{"community"},
                              -port         => 161,
                              -version      => $config{"snmp_version"},
                              -retries      => $config{"snmp_retries"},
                              -timeout      => $config{"snmp_timeout"},
                              -nonblocking   => 0x1 );
   if (!defined($snmp)) {
      printlog('err', "ERROR: SNMP connect error: " . $error);
      next;
   }
   if ( $sql_id->{type} eq "snmp_net" ) {
      $oid = $oidOctets{$sql_id_field_value{"inout"}} . "." .
$sql_id_field_value{"ifnum"};
   } elsif   ( $sql_id->{type} eq "snmp" ) {
      $oid = $sql_id_field_value{"oid"};
   } else {
      printlog('err', "ERROR: Datasource " . $sql_id->{name} . "has an invalid
type: " . $sql_id->{type});
      next;
   }
   printlog('debug', " OID to get = $oid");
   $result = $snmp->get_request(
                        -varbindlist   => [ $oid ],
                        -callback      => [ \&get_snmp_data, $oid, $sql_id,
$out_field ] );
   if (!$result) {
      printlog('err', "ERROR: During SNMP get_request Setup (" .
$snmp->error() . ")");
      $snmp->close();
   }
}

printlog('debug', "SENDING ALL SNMP requests...");
Net::SNMP->snmp_dispatcher();
printlog('debug', "END spine.pl " . localtime());
exit 0;

#
# FUNCTIONS....
#

# get_cacti_config: Gather configuration parameters from cacti MySQL DB
sub get_cacti_config {
   my($sth, $parameter);
   $sql   = "SELECT Name, Value FROM settings";
   $sth   = $dbh->prepare($sql);
   $sth->execute() or do {
                     printlog('err', "ERROR: Could not execute SQL! Error: " .
$dbh->errstr );
                     exit 1;
                     };
   while ( $parameter = $sth->fetchrow_hashref() ) {
      $config{ $parameter->{Name} }   = $parameter->{Value};
      printlog('debug', "get_cacti_config(): " . $parameter->{Name} . "=" .
$parameter->{Value});
   }
   $sth->finish();
   $config{"path_cacti"}   = $config{"path_webroot"} .
$config{"path_webcacti"};
   $config{"path_images"}   = $config{"path_cacti"} . "/graphs";
   $config{"path_rra"}      = $config{"path_cacti"} . "/rra";
   $config{"path_log"}      = $config{"path_cacti"} . "/log/rrd.log";
   if (! -d $config{"path_cacti"} ) {
      printlog('err', "ERROR: cacti path " . $config{"path_cacti"} . " is not
a directory or does not exists!");
      exit 1;
   }
   return;
}

# printlog: To send a message to the log (syslog)
sub printlog {
   my($level, $msg, $facility);
   $level      = shift @_;
   $msg      = shift @_;
   $facility   = ( ( !defined($config{'syslog_facility'}) ) ? 'local5' :
$config{'syslog_facility'} );
   if ( $level =~ /debug/i && !$config{'debug'} ) {
      return;
   }
   if ( !  openlog($0, 'cons,pid', $facility) ) {
      print STDERR "No se pudo abrir SYSLOG: $0\t$facility\.$level\t$msg\n";
      return;
   }
   syslog($level, '%s', $msg);
   closelog();
   if ($config{'debug'}) {
      open  LOG, ">>/tmp/$0.log" or return;
      print LOG localtime() . " [$0 -> $facility\.$level] $msg\n";
      close(LOG);
   }
   return;
}

# get_snmp_data: Handles the SNMP response when the DS is type SNMP Network
sub get_snmp_data {
   my ($session, $oid, $sql_id, $out_field) = @_;
   my $host      = $session->hostname;
   my $out_data   = '';
   if (!defined($session->var_bind_list)) {
      my $error  = $session->error;
      printlog('err', "ERROR: get_snmp_data($host) Error: " . $error);
   } else {
      my $result = $session->var_bind_list->{$oid};
      printlog('debug', "get_snmp_data($host) $oid = $result");
      $out_data = "$result";
   }
   update_src_data($sql_id, $out_field, $out_data);
   rrdtool_function_create($sql_id->{id}, 0);
   if ($sql_id->{srcid} != 0) {
      rrdtool_function_update($sql_id->{id}, 0, 0);
   }
   return;
}

# update_src_data: Store received SNMP data on CACTI's MySQL tables...
sub update_src_data {
   my ($sql_id, $out_field, $out_data) = @_;
   if ($sql_id->{srcid} == 0) {
      printlog('err', "ERROR: Data Source: " . $sql_id->{name} . " does not
have a data input source assigned to it. No data will be gathered; if cacti
does not gather data for this data source please deactivate it.");
      return;
   }
   $sql   = "SELECT id " .
           "FROM src_fields " .
           "WHERE  dataname = '$out_field' " .
           " and   srcid = " . $sql_id->{srcid} .
           " and   inputoutput='out'";
   my $sth1 = $dbh->prepare($sql);
   $sth1->execute() or do {
                     printlog('err', "ERROR: Could not execute SQL! Error: " .
$dbh->errstr );
                     exit 1;
                     };
   my $sql_id_fields = $sth1->fetchrow_hashref();
   my $current_data_source_id = $sql_id->{id};
   $sql   = "SELECT id " .
            "FROM src_data " .
            "WHERE fieldid = " . $sql_id_fields->{id} .
            " and dsid = $current_data_source_id";
   my $sth2 = $dbh->prepare($sql);
   $sth2->execute() or do {
                     printlog('err', "ERROR: Could not execute SQL! Error: " .
$dbh->errstr);
                     exit 1;
                     };
   my $new_data_id = 0;
   if ($sth2->rows > 0) {
      my $sql_id_data = $sth2->fetchrow_hashref();
      $new_data_id = $sql_id_data->{id};
   }
   $sql   = "REPLACE INTO src_data " .
            "(id, fieldid, dsid, value) " .
            "values (" .
            "$new_data_id, " .
            $sql_id_fields->{id} . ", " .
            "$current_data_source_id, " .
            "'$out_data')";
   printlog('debug', "update_src_data(" . $sql_id->{name} . ") Replace SQL =
$sql");
   my $affected_rows = 0;
   $affected_rows = $dbh->do($sql);
   if (! $affected_rows ) {
      printlog('err', "WARN: MySQL REPLACE didn't affect any rows...??");
   }
   return;   
}

#
# CACTI's ported functions...
#
sub CheckDataSourceName {
   my $data_source_name = shift;
   $data_source_name =~ s/\s/_/g;
   $data_source_name =~ s/[\/\*\\\&\%\"\',\.]+//g;
   $data_source_name = substr($data_source_name,0,19);
   return lc($data_source_name);
}

sub GetDataSourceName {
   my $dsid = shift;
   if ($dsid == 0) { return ""; }
   $sql = "select name, dsname from rrd_ds where id=$dsid";
   my $sth1 = $dbh->prepare($sql);
   $sth1->execute() or do {
                     printlog('err', "ERROR: Could not execute SQL! Error: " .
$dbh->errstr);
                     exit 1;
                     };
   if ($sth1->rows <= 0) {
      printlog('err', "ERROR: DataSource Name NOT found!");
      return "";
   }
   my $sql_id = $sth1->fetchrow_hashref();
   if ($sql_id->{dsname} eq "") {
      return CheckDataSourceName($sql_id->{name});
   } else {
      return $sql_id->{dsname};
   }
}

sub GetDataSourcePath {
   my ($data_source_id, $expand_paths) = @_;
   my $data_source_path = '';
   if ($data_source_id == 0) { return ""; }
   $sql = "select name, dspath from rrd_ds where id = $data_source_id";
   my $sth1 = $dbh->prepare($sql);
   $sth1->execute() or do {
                     printlog('err', "ERROR: Could not execute SQL! Error: " .
$dbh->errstr );
                     exit 1;
                     };
   if ($sth1->rows > 0) {
      my $sql_id = $sth1->fetchrow_hashref();
      if ($sql_id->{dspath} eq "") {
         $data_source_path = "<path_rra>/" .
CheckDataSourceName($sql_id->{name}) . ".rrd";
      } else {
         if ($sql_id->{dspath} !~ /\//) {
            $data_source_path = "<path_rra>/" . $sql_id->{dspath};
         } else {
            $data_source_path = $sql_id->{dspath};
         }
      }
      if ($expand_paths) {
         $data_source_path =~ s/<path_rra>/$config{"path_rra"}/g;
      }
      return $data_source_path;
   }
}

sub rrdtool_function_create {
   my ($dsid, $show_source) = @_;
   my $data_source_path   = GetDataSourcePath($dsid, 1);
   my $create_ds         = '';
   my $create_rra         = '';
   my @args            = ();
   if (!$show_source) {
      if ( -f $data_source_path ) {
         printlog('err', "WARN: rrd file $data_source_path already exists!");
         return -1;
      }
   }
   $sql = "select
         d.step,
         r.xfilesfactor, r.steps, r.rows,
         c.name as cname,
         (r.rows*r.steps) as rs
         from rrd_ds d left join lnk_ds_rra l on l.dsid=d.id
         left join rrd_rra r on l.rraid=r.id
         left join lnk_rra_cf rc on rc.rraid=r.id
         left join def_cf c on rc.consolidationfunctionid=c.id
         where d.id=$dsid
         order by rc.consolidationfunctionid, rs";

   my $sth1 = $dbh->prepare($sql);
   $sth1->execute() or do {
                     printlog('err', "ERROR: Could not execute SQL! Error: " .
$dbh->errstr);
                     exit 1;
                     };
   if ($sth1->rows <= 0) {
      printlog('err', "ERROR: There are no RRA's assigned to DSID $dsid!");
      return -1;
   }
   my $sql_id = $sth1->fetchrow_hashref();
   push @args, "--step";
   push @args, $sql_id->{step};
   $sql = "select
         d.id, d.heartbeat, d.minvalue, d.maxvalue,d.subdsid,
         t.name
         from rrd_ds d left join def_ds t on d.datasourcetypeid=t.id
         where d.id=$dsid
         or d.subdsid=$dsid
         order by d.id";
   my $sth2 = $dbh->prepare($sql);
   $sth2->execute() or do {
                     printlog('err', "ERROR: Could not execute SQL! Error: " .
$dbh->errstr);
                     exit 1;
                     };
   my $sql_id_ds;
   my $rows = $sth2->rows;
   while ($sql_id_ds = $sth2->fetchrow_hashref()) {
      if ( ($rows > 1 and $sql_id_ds->{subdsid} != 0) or ($rows == 1)) {
         my $data_source_name = GetDataSourceName($sql_id_ds->{id});
         push @args, "DS:$data_source_name:" .
            $sql_id_ds->{name} . ":" .
            $sql_id_ds->{heartbeat} . ":" .
            $sql_id_ds->{minvalue} . ":" .
            $sql_id_ds->{maxvalue};
      }
   }
   do {
      push @args, "RRA:" . $sql_id->{cname} . ":" .
         $sql_id->{xfilesfactor} . ":" .
         $sql_id->{steps} . ":" .
         $sql_id->{rows};
   } while ($sql_id = $sth1->fetchrow_hashref());
   
   printlog('debug', "rrdtool create $data_source_path " . join(' ', @args));
   if (!$show_source) {
      RRDs::create($data_source_path, @args);
      if ($RRDs::error) {
         printlog('err', "ERROR: rrdtool create $data_source_path failed! (" .
$RRDs::error . ")");
      } else {
         printlog('debug', "RRA file $data_source_path Created!");
      }
   }
   return;
}

sub rrdtool_function_update {
   my ($dsid, $multi_data_source, $show_source) = @_;
   my $data_source_path= GetDataSourcePath($dsid, 1);
   my $update_string   = "N";
   my $template_string   = "";
   
   if ($multi_data_source eq "") {
      $sql = "select id from rrd_ds where subdsid=$dsid";
      my $sth1 = $dbh->prepare($sql);
      $sth1->execute() or do {
                        printlog('err', "ERROR: Could not execute SQL! Error:
" . $dbh->errstr);
                        exit 1;
                        };
      if ($sth1->rows == 0) {
         $multi_data_source = 0;
      } else {
         $multi_data_source = 1;
      }
   }
   
   if ($multi_data_source == 1) {
      $sql = "select
            d.dsname,
            a.value
            from rrd_ds d left join src_fields f on d.subfieldid=f.id
            left join src_data a on d.id=a.dsid
            where d.subdsid=$dsid
            and f.inputoutput=\"out\"
            and f.updaterra=\"on\"
            order by d.id";
   } else {
      $sql = "select
            d.dsname,
            a.value
            from rrd_ds d left join src_data a on d.id=a.dsid
            left join src_fields f on a.fieldid=f.id
            where d.id=$dsid
            and f.inputoutput=\"out\"
            and f.updaterra=\"on\"
            order by d.id";
   }
   my $sth2 = $dbh->prepare($sql);
   $sth2->execute() or do {
                     printlog('err', "ERROR: Could not execute SQL! Error: " .
$dbh->errstr);
                     exit 1;
                     };
   my $rows = $sth2->rows();
   my $data_value = "U";
   my $i = 0;
   while (my $sql_id = $sth2->fetchrow_hashref()) {
      if ($sql_id->{value} =~ /[0-9\.]+/i) {
         $data_value = $sql_id->{value};
      }
      $update_string .= ":$data_value";
      $template_string .= $sql_id->{dsname};
      $i++;
      if ($i < $rows) { $template_string .= ":"; }
   }

   my $command_line = "update $data_source_path --template $template_string
$update_string";

   printlog('debug', "rrdtool " . $command_line);   
   if (!$show_source) {
      RRDs::update($data_source_path, "--template", $template_string,
$update_string);
      if ($RRDs::error) {
         printlog('err', "ERROR: rrdtool update $data_source_path failed! (" .
$RRDs::error . ")");
      } else {
         printlog('debug', "RRA file $data_source_path Updated!");
      }
   }
   return;
}