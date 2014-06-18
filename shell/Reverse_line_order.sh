#! /bin/bash
#  Reverse_line_order.sh
#  Usage: Reverse_line_order.sh filename
Myfile=$1
if [ -f $Myfile ];then
	sed -i -n '{1!G;$!h;$p}' $Myfile
else
	echo "Sorry,$Myfile is not a file"
	exit 1
fi



##########################################
tac $Myfile


##########################################

rev $Myfile #翻转每行的输出，但不会改变行序