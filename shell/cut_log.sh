#! /bin/bash
# cut_log.sh

#######################################################################################################
# This script will run at 00:00 every day.Through this script,nginx's access log will be cut in days. #
# The access_log will be synchronized to awstats_server(172.16.83.121)                                #
# The access_log and error_log before 30 days ago will be deleted.                                    #
# created by shidegang.2013-10-8                                                                      #
#######################################################################################################

#Begin
#Define variables

NGINX=/usr/sbin/nginx
LOG_FROM_PATH=/var/log/service/nginx/
LOG_TO_PATH=/data/logbackup/nginx/
DAY=`date -d '-1 day' +%Y%m%d`

#  dir exit?

if [ ! -d ${LOG_TO_PATH} ];then
mkdir -p ${LOG_TO_PATH} 
fi

#cut access_log

#for i in 3drich.com.cn \
#stylemode.com \
#styleauto.com.cn \
#stylehouse.com.cn
#do
#mv ${LOG_FROM_PATH}$i/access.log ${LOG_TO_PATH}access/$i-$DAY.log
#done

#cut error_log
#mv ${LOG_FROM_PATH}nginx_error.log ${LOG_TO_PATH}error/error-$DAY.log

# reopen nginx logs
#$NGINX -s reopen

#compress the log file with gzip
gzip -9 ${LOG_TO_PATH}access/*-$DAY.log
gzip -9 ${LOG_TO_PATH}error/*-$DAY.log

#synchronized the log files to 172.16.83.121
rsync -az ${LOG_TO_PATH}access/*-$DAY.log 
#The end

