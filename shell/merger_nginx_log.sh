#! /bin/bash
# merger_log.sh
# This script running at 00:30 every day,merger log files from web161 and web162 to one big file
# created by shidegang 20131008
# Begin
DAY=`date -d '-1 day' +%Y%m%d`
DAY_BEFORE_YESTERDAY=`date -d '-2 day' +%Y%m%d`
LOG_FROM_PATH=/var/log/service/nginx/
LOG_TO_PATH=/var/log/service/nginx/merger/

gunzip ${LOG_FROM_PATH}web161/*-$DAY.log.gz
gunzip ${LOG_FROM_PATH}web162/*-$DAY.log.gz
#merger log files
for i in 3drich.com.cn \
	stylemode.com \
	styleauto.com.cn \
	stylehouse.com.cn
do
	sort -m -t " " -k 4 -o ${LOG_TO_PATH}$i/$i-$DAY.log ${LOG_FROM_PATH}web161/$i-$DAY.log ${LOG_FROM_PATH}web162/$i-$DAY.log
#compress log file 2 days ago
	gzip -9 ${LOG_TO_PATH}$i/$i-${DAY_BEFORE_YESTERDAY}.log
#delete log file 15 days ago
	find ${LOG_TO_PATH}$i -mtime +15 | xargs -i rm -rf {}
done
#delete log files from web_servers
rm -f ${LOG_FROM_PATH}web161/*
rm -f ${LOG_FROM_PATH}web162/*

#The end
