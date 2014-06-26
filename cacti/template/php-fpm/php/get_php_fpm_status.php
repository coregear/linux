<?php
#!/usr/bin/php -q
/* do NOT run this script through a web browser */
if (!isset($_SERVER["argv"][0]) || isset($_SERVER['REQUEST_METHOD'])  || isset($_SERVER['REMOTE_ADDR'])) {
   die("<br><strong>This script is only meant to run at the command line.</strong>");
}

$default['host'] = '';                   # server host
$default['script'] = '/statusfpm';       # test script (absolute path starting at / - root directory -)
$default['port'] = 80;                   # tcp port
$default['timeout'] = 3;                 # timeout in seconds

$args = array();
@list(, $args['host'], $args['script'], $args['port'], $args['timeout']) = $_SERVER["argv"];
foreach($args as $key => $value)
	$args[$key] = ($value)? $value : $default[$key]; 

if (($args['host'] == '') || ($args['port'] == '')) {
  print "Usage: get_php_fpm_status.php <host> [<test script>] [<port>] [<timeout seconds>]\n";
  exit(-1);
}

$content = file_get_contents('http://'.$args['host'].':'.$args['port'].$args['script']); 
$result = preg_match("/accepted conn:\s+(\d+)\s*\n/i", $content, $matches);
$conn['accepted'] = ($result)? $matches[1] : 'n/a'; 
$result = preg_match("/idle processes:\s+(\d+)\s*\n/i", $content, $matches);
$conn['idle'] = ($result)? $matches[1] : 'n/a';
$result = preg_match("/active processes:\s+(\d+)\s*\n/i", $content, $matches);
$conn['active'] = ($result)? $matches[1] : 'n/a';
$result = preg_match("/total processes:\s+(\d+)\s*\n/i", $content, $matches);
$conn['total'] = ($result)? $matches[1] : 'n/a';
echo 'accepted:' . $conn['accepted'] . ' idle:' . $conn['idle'] . ' active:'. $conn['active'] . ' total:' . $conn['total'] . "\n";
