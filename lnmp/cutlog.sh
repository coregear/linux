#!/bin/bash
# This script run at 00:00
# cut yesterday log and gzip the day before yesterday log files.
# yesterday logs to awstats

# The Nginx logs path
logs_from_path="/usr/local/nginx/logs/"
logs_to_path="/data/logs/nginx/"

DAY=`date -d '-1 day' +%Y%m%d`
DAY_BEFORE=`date -d '-2 day' +%Y%m%d`
NGINX=/usr/local/nginx/sbin/nginx

#begin
for i in bbs cms train job phper uc
do
    mv ${logs_from_path}$i-access.log  ${logs_to_path}access/$i-$DAY.log
done
mv ${logs_from_path}access.log  ${logs_to_path}access/access-$DAY.log
mv ${logs_from_path}error.log  ${logs_to_path}error/error-$DAY.log

$NGINX -s reopen

gzip -9  ${logs_to_path}access/*${DAY_BEFORE}.log
gzip -9  ${logs_to_path}error/error-$DAY.log
find ${logs_to_path}access -mtime +30 | xargs -i rm -rf {}
find ${logs_to_path}error -mtime +30 | xargs -i rm -rf {}