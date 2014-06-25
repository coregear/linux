#!/bin/bash

# inotify_nfs_upload.sh

# This script will run in the background.When file that in /Data/nfs/upload/ has changed,
# this script will push these changes to 10.10.67.81 with rsync
# Created by shidegang at 2013.11.04

src=/Data/nfs/upload/
user=rsync_user
host=10.10.67.81
module=upload
INOTIFYWAIT=/usr/local/bin/inotifywait

$INOTIFYWAIT -mrq --timefmt '%d/%m/%y %H:%M' --format  '%T %w %f %e' --event close_write,delete,create,move,attrib --exclude '(.swp|.swx|.svn)' $src | while read date time dir file event
do
        case $event in
                CLOSE_WRITE,CLOSE|CREATE,ISDIR|MOVED_TO|MOVED_TO,ISDIR)
                if [ "${file: -4}" != '4913' ]  && [ "${file: -1}" != '~' ]; then
                         rsync -az --password-file=/etc/rsync.pas $src $user@$host::$module > /dev/null 2>&1
                fi
        ;;

                MOVED_FROM|MOVED_FROM,ISDIR|DELETE|DELETE,ISDIR)
                if [ "${file: -4}" != '4913' ]  && [ "${file: -1}" != '~' ]; then
                        rsync -az --delete --password-file=/etc/rsync.pas $src $user@$host::$module > /dev/null 2>&1
                fi
        ;;
        esac
done

# End