#/ bin/bash

# 依赖
yum install gcc gcc-c++ gibc-static cloog-ppl gmp-devel

# isl
wget ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.12.2.tar.bz2
tar jxvf isl-0.12.2.tar.bz2 && cd isl-0.12.2
./configure
make
make install

#gcc

#获取最新gcc源码
#svn checkout svn://gcc.gnu.org/svn/gcc/trunk  localdir
cd localdir/gcc
mkdir build

#下载gmp，mpfr，mpc源码，gcc-4.10.tgz里已经包含下载完的三个源码包，不必再次下载
./contrib/download_prerequisites 

cd build
../configure --prefix=/usr --enable-languages=c,c++ --disable-multilib

make -j4 
#make -j选项，与cpu个数及线程数有关

make install

