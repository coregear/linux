#!/bin/bash
#DB_DIR=/usr/local/mysql/data
#Modify 2010 08 10
#by shidegang

BACK_DIR=/data/bak/mysql

DB_LST=/tmp/db.lst

DATE=`date +%Y-%m-%d` 

export PATH=$PATH:/usr/local/mysql/bin

mysql -u root -p'' -e 'show databases' > $DB_LST

[ ! -d $BACK_DIR ] && mkdir -p $BACK_DIR
for i in $(grep -vE "Database|information_schema|test" $DB_LST)
do
	mysqldump --user='root' --passwor='' --default-character-set=utf8  $i > $BACK_DIR/$i-$DATE.sql
	[ "$PWD" != "$BACK_DIR" ] && cd $BACK_DIR 
	gzip  -f $BACK_DIR/$i-$DATE.sql
done


find $BACK_DIR -mtime +7 | xargs -i rm -rf {}
