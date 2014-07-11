1 赋值与test的区分 (=  /  -eq)

2 shell接受传递外部参数，$0为脚本名字，$1为第一个参数，$2第二个……$9第九个，如果需要更多参数需要使用大括号，如${10}

$MINPARAMS  设置脚本需要传递的参数个数
$#  实际传递给shell的参数的个数

if [ $# -lt $MINPARAMS ];then echo "error,need at least $MINPARAMS 个参数！"

3 直接引用变量与双引号引用变量的区别

a=`ls -l`

echo $a  #不保留空白、换行等

echo "$a" #保留空白、换行，即维持原格式

4 echo -n 使输出不换行，内容总在同一行位置输出。

5 a=(1 2 3 4)

这样赋值把a作为一个数组，echo ${a[1]},将输出2

6 ~代表家目录，~+代表当前工作目录 ~-代表上一个工作目录

7 -可用于重定向stdin或stdout

(cd /usr/local/src && tar cf - .) | (cd /mnt && tar xpvf -)

这条命令的作用是把/usr/local/src下的所有内容转移到/mnt下，也就是在源目录将文件打包后重定向到stdout,然后到目标目录将打包的内容作为stdin进行解包的操作。省略了真实生成打包文件，然后再对这个真实打包文件进行解包的过程。（）代表一个命令组

8 if [ -z $1 ]  if [ -n $1 ]
shell脚本中判断参数是否传递,z，变量的为空，n，不为空

9 shift 将shell脚本的参数向左移动一位，原来的$2变$1,$3变$2……

until [ -z $1 ]  #打印所有参数，直到不在存在$1,即所有参数均已用光。
do 
echo -n $1
shift          #shift的作用在这里
done

10 变量自增的实现方
     count=$[ $count + 1 ]  
     
     count=$(($count+1))
     
     let "count += 1"
done

11 if能够测试的不仅仅是括号中的内容，可以用来测试任何命令

if grep 111 file
then
echo "在文件file中至少包含一个关键字111"
else
echo "不包含此关键字"
fi

12 （（）） 结构，用来进行算术计算或者比较，计算结果为0返回1，计算结果非0返回0
（（0））
（（1））
（（5>4））
 ((5/4))

13 shell中的文件测试
-s 文件长度不为0
-g 文件是否设置了sgid
-u 文件是否设置了suid
f1 -nt f2 文件f1比文件f2新
f1 -ot f2 文件f1比f2老
-e
-d
-f
-r
-w
-x
所有测试都可以用！取反

整数比较 
-eq 
-ne
-gt  -ge
-lt  -le
字符串比较
=
==
!=
-z 字符串为null,即长度为0
-n 不为null

============================================================
字符串操作
14 计算字符串长度

${#string}

expr length $string

expr "$string" : '.*'

15 提取字符串
${string:positon:length}
例子：
stringZ=1234567
echo ${stringZ:0}     1234567
echo ${stringZ:1}     234567
echo ${stringZ:3:2}   45 

#从倒数第三个字符提取，默认提取至字符串末尾,也就是保留最后四个字符。
echo ${stringZ: -3}   4567  一定要注意-3和冒号之间有一个空格隔开

16 截去字符串 （注意是截去，不是截取）
例子：
stringZ=abcABC123ABCabc
echo ${stringZ#a*C}   最近匹配，去掉从左边起第一个能匹配a*C模式的子串，结果是123ABCabc
echo $｛stringZ##a*C｝ 最远匹配，去掉左边其最后一个能匹配a*C模式的子串，结果是abc

echo ${stringZ%b*c} 最近匹配，从右边开始匹配，结果是abcABC123ABCa

echo ${stringZ%%b*c} 最远匹配，从右边开始匹配，结果是a


17 子串替换
例子
stringZ=abcABC123ABCabc

echo ${stringZ/abc/xyz} 将第一个abc替换为xyz,结果为xyzABC123ABCabc

echo ${stringZ//abc/xyz} 将所有abc替换为xyz

echo ${stringZ/#abc/xyz} 替换字符串开头的abc

echo ${stringZ/%abc/xyz} 替换结尾的abc

18 变量替换
$(cmd)
`cmd`
${var:-string} #如果$var为空则用string替换${var:-string},$var仍为空
${var:=string} #如果$var为空则用string替换${var:-string},$var被赋值为string
${var:+string} #如果$var不为空则用string替换${var:-string},如果$var为空则不替换
${var:?string} #如果$var不为空则用$var的值替换${var:-string},$var为空的话string被输出到标准输出

19 $(()) 结构

$ echo $((3+2)) 
5 
$ echo $((3>2)) 
1 
$ echo $((25<3 ? 2:3)) 
3 
$ echo $var

$ echo $((var=2+3)) 
5 
$ echo $var 
5 
$ echo $((var++)) 
5 
$ echo $var 
6 
