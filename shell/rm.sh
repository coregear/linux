#! /bin/bash

#until  [ -z $1 ]
#do
#        echo -n $1
#        shift
#done
#
#args=$@
#cmd="ls $args"
#echo $args
#eval $cmd
#a=""
#echo $a
#echo
#a=${a:-3}
#echo $a
#if [[ x$a -eq x"1" ]];then
#    echo "a is null"
#fi
MINPARAMS=1
[ $# -lt $MINPARAMS ] && echo "more than one params needed" 
exit

function my_rm() {
    local sub_dir=`date +%Y%m%d`
    [[ ${1:0:1} == "-" ]] && shift
    local dir=/home/shidg/${sub_dir}
    [[ -d $dir ]] || mkdir -p $dir
    until [ -z "$1" ];do
        if [ -d "$1" ];then
            find "$1" -type f -print0 | xargs -0 -i mv -t $dir {}
        else
            mv  -t $dir "$1"
        fi
        shift
    done
}
my_rm "$@"
