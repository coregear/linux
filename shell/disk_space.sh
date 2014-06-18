#! /bin/bash
# disk_space
# show top ten disk space usage
# usage: disk_space [dir_name] [dir_name]
if [ $# -eq 0 ];then
	echo "Usage: `basename $0` dirname"
	exit 1
fi
tmpfile=`mktemp -t diskXXXXXX`
for i in `echo $*`
do
DIR=$i

du -Sh $DIR  | sort -nr | head > $tmpfile

echo "The $DIR directory:"

# 为输出添加行号，并使用awk格式化输出
sed  '=' $tmpfile | sed  'N;s/\n/  /' | awk '{printf "%2d\t %9s\t %s\n", $1, $2, $3}'
done
rm -f $tmpfile
