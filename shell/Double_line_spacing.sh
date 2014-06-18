# /bin/bash
# Double_line_spacing
# usage: Double_line_spacing.sh [filename] [filename] ..
if [ $# -eq 0 ];then
	echo "Usage:`basename $0` [filename] [filenmae]"
	exit 1
fi
#判断传入的参数是否为文件
for i in `echo $*`
do
	if [ ! -f $i ];then
	echo "sorry,$i is not a file"
	#kill -9 $$
	exit 1
	fi
done

# 逐一处理每个参数，用户可同时处理多个文件
while [ -n "$1" ] #这里这个""不可少，否则判断会出问题
#until [ -z "$1" ]
do
file=$1
echo "Filename: $1"
#文件中可能原本就有空白行，先将这些空白行去掉，不然会有某些行之间出现多个空白行
sed '/^$/d' $1 
sed '/^$/d' $file | sed '$!G' 
shift
done
