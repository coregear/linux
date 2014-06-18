#! /bin/bash
# del_html
# delete all html tags
# usage: del_html [filename]
file=$1
sed 's/<[^>]*>//g' $file #去掉所有html标签

sed '/<html>/,/<\/html>/!d' $file | sed '1d;$d'#截取<html>和</html>之间的内容