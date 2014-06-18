#! /bin/bash
# merger_log.sh
# This script running at 00:30 every day,merger log files from web161 and web162 to one big file
# created by shidegang 20131008
# Begin
DAY=`date -d '-1 day' +%Y%m%d`
DAY_BEFORE_YESTERDAY=`date -d '-2 day' +%Y%m%d`
LOG_FROM_PATH=/var/log/service/varnish/
LOG_TO_PATH=/var/log/service/varnish/merger/

gunzip ${LOG_FROM_PATH}varnish110/*-$DAY.log.gz
gunzip ${LOG_FROM_PATH}varnish111/*-$DAY.log.gz
#merger log files
sort -m -t " " -k 4 -o ${LOG_TO_PATH}/varnish-$DAY.log ${LOG_FROM_PATH}varnish110/access-$DAY.log ${LOG_FROM_PATH}varnish111/access-$DAY.log
#compress log file 2 days ago
gzip -9 ${LOG_TO_PATH}varnish-${DAY_BEFORE_YESTERDAY}.log
#delete log file 15 days ago
find ${LOG_TO_PATH} -mtime +15 | xargs -i rm -rf {}
find ${LOG_FROM_PATH}varnish110/ -mtime +15 | xargs -i rm -rf {}
find ${LOG_FROM_PATH}varnish111/ -mtime +15 | xargs -i rm -rf {}

#The end
