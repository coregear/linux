#! /bin/bash
for ((i=1;i<=9;i++))
do
	for((a=1;a<=$i;a++))
	do
		#echo -ne "$a*$i"=$(($a*$i))" "
		#echo -ne "$a*$i"=$[$a * $i]" "
		#echo -ne "$a*$i"=`expr $a \* $i`" "
		let "b=$a * $i"
		echo -ne "$a*$i"=$b" "
	done
	echo
done
