README 
mysql_stats.php
version 2.0.1
enables cacti to read mysql statistics
support: Scott McCarty <scott.mccarty@gmail.com>
author: Otto Berger berger@hk-net.de
date: 2005/01/18 - 2011

INSTALLATION
============

1. put the mysql_stats.php file inside the cacti/scripts/ directory
2. import the .xml-Files using the cacti webinterface

To upgrade a previous installation, have a look below.

USAGE
=====

Configure the mysql-server you want to graph. To enable access from the
cacti-machine to the mysql-status informations, you must have the 
"process" right.

Use for example the following mysql-command to set the process-right for the
mysql-user "cactiuser" with the password "cactipasswd":

GRANT PROCESS ON *.* TO cactiuser@'localhost' IDENTIFIED by 'cactipasswd';

To monitor a foreign host, fill in the hostname where you came from, 
for example:

GRANT PROCESS ON *.* TO cactiuser@'cactihost.com' IDENTIFIED by 'cactipasswd';


GRAPH CREATION
==============

1. Click inside cacti on "New Graphs"
2. Choose host and a mysql-template
3. Click create
4. Fill in the MySQL-username and password as specified obove
5. Finished!


UPGRADE
=======

Put the new mysql_stats.php file inside the cacti/scripts/ directory
You can now delete the other mysql_* php-files...

--> Normally the import of the xml-files using the cacti-interface
--> would be enough to upgrade.


In case of errors, or to prevent them, you have to edit the 
"data input methods" manually through the webinterface. For each MySQL-
input method you have to change the input string to one of the following:

MySQL - QCache statistics:
<path_php_binary> -q <path_cacti>/scripts/mysql_stats.php cache <hostname> <username> <password>

MySQL - Single Statistics:
<path_php_binary> -q <path_cacti>/scripts/mysql_stats.php status <hostname> <username> <password> <query>

MySQL - Handler statistics:
<path_php_binary> -q <path_cacti>/scripts/mysql_stats.php handler <hostname> <username> <password>

MySQL - Command statistics:
<path_php_binary> -q <path_cacti>/scripts/mysql_stats.php command <hostname> <username> <password>

MySQL - Thread statistics:
<path_php_binary> -q <path_cacti>/scripts/mysql_stats.php thread <hostname> <username> <password>


