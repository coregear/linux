tar zxvf swatch-3.2.3.tar.gz

cd swatch-3.2.3

perl MakeFile.PL

#如提示缺少perl模块，则首先安装提示的模块

make 

make test

make install

make realclean


###

使用

touch /root/swatchrc

vi /root/swatchrc

watchfor /[Ff]ail/

echo red

exec "psad --fw-block-ip …………"

swatch -c /root/swatchrc -t /var/log/messages

