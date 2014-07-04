# get source
wget http://sourceforge.net/projects/tmux/files/tmux/tmux-1.9/tmux-1.9a.tar.gz
or
git clone git://git.code.sf.net/p/tmux/tmux-code tmux
cd tmux
sh autogen.sh
./configure && make


###dep###
从1.8版开始，tmux depends on libevent 2.x. 
否则会有 make *** control.o error 1 的错误

删除旧版本libevent，安装最新版

tar zxvf libevent-2.0.21-stable.tar.gz && cd libevent-2.0.21-stable
./configure --prefix=/usr
make && make install


# install

tar zxvf tmux-1.9a.tar.gz && cd tmux-1.9a
./configure
make && make install

#############################################################
###By default, `make install' will install all the files in##
###'/usr/local/bin', '/usr/local/lib' etc.                 ##
#############################################################


