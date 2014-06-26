<?php
/* mysql_stats.php
 * enables cacti to read mysql statistics
 * by berger@hk-net.de 2005/01/18
 *
 * usage:
 * mysql_stats.php section db_host db_user db_password [status_var]
 * sections:
 * cache, command, handler, thread, traffic, status
*/

if ($_SERVER["argc"] == 5 || ($_SERVER["argv"][1] == "status" && $_SERVER["argc"] == 6)) {

	$host     = $_SERVER["argv"][2];
	$username = $_SERVER["argv"][3];
	$password = $_SERVER["argv"][4];

	if (@mysql_connect($host, $username, $password)) {
		$result_stat = @mysql_query("SHOW /*!50002 GLOBAL */ STATUS");
		while ($fld_stat = @mysql_fetch_row($result_stat)) {
			$status[$fld_stat[0]] = $fld_stat[1];
		}

		$result_var = @mysql_query("SHOW /*!50002 GLOBAL */ VARIABLES");
		while ($fld_var = @mysql_fetch_row($result_var)) {
			$variables[$fld_var[0]] = $fld_var[1];
		}
	} else {
		die("Error: MySQL connect failed. Check MySQL parameters (host/login/password)\n");
	}
	
	if (!is_array($status) || !is_array($variables)) {
		die("Error: Cannot get statistics. Check MySQL server permissions\n");
	}

	switch($_SERVER["argv"][1]) {
	case "cache" :
		$output = "used:" 		. ($variables["query_cache_size"]-$status["Qcache_free_memory"]) . " "
				 ."available:" 	. $status["Qcache_free_memory"];
	break;
	case "command" :
		$output = "change_db:" . $status["Com_change_db"] . " "
				 ."delete:"    . $status["Com_delete"] . " "
				 ."insert:"    . $status["Com_insert"] . " "
				 ."select:"    . $status["Com_select"] . " "
				 ."update:"    . $status["Com_update"];
	break;
	case "handler" :
		$output = "delete:" 		. $status["Handler_delete"] . " "
				 ."read_first:" 	. $status["Handler_read_first"] . " "
				 ."read_key:"   	. $status["Handler_read_key"] . " "
				 ."read_next:"  	. $status["Handler_read_next"] . " "
				 ."read_prev:"  	. $status["Handler_read_prev"] . " "
				 ."read_rnd:"   	. $status["Handler_read_rnd"] . " "
				 ."read_rnd_next:" 	. $status["Handler_read_rnd_next"] . " "
				 ."update:"			. $status["Handler_update"] . " "
				 ."write:"			. $status["Handler_write"];
	break;
	case "thread" :
		$output = "connected:" . $status["Threads_connected"] . " "
				 ."running:"   . $status["Threads_running"] . " "
				 ."cached:"    . $status["Threads_cached"];
	break;
	case "traffic" :
		$output = "in:"		. $status["Bytes_received"] . " "
				 ."out:"	. $status["Bytes_sent"];
	break;
	case "status" :
		if (!isset($_SERVER["argv"][5])) {
			die("Error: wrong parameter count\nUsage: mysql_stats.php db_host db_user db_password status_var\n");
		}
		$output = $status[$_SERVER["argv"][5]];
	break;
	default :
		die("Error: undefinded parameter given.\nUse one of these: cache, commands, handler, thread, status, traffic\n");
	}

	echo $output;
	
} else {
	die("Error: wrong parameter count\nUsage: mysql_stats.php section db_host db_user db_password [status_var]\n");
}
?>
