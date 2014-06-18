#vim 版本大于7.3.584

#升级vim
yum install ncurses-devel perl-ExtUtils-Embed python-devel

wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2

tar jxvf vim-7.4.tar.bz2 && cd vim74
./configure --with-features=huge  --enable-pythoninterp=yes --with-python-config-dir=/usr/lib64/python2.6/config/ --enable-perlinterp=yes  --enable-cscope --enable-luainterp --enable-perlinterp --enable-multibyte --prefix=/usr

make -j4 && make install

#==============================================================================================

#升级gcc

# 依赖
yum install gcc gcc-c++ gibc-static cloog-ppl gmp-devel

# isl
wget ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.12.2.tar.bz2
tar jxvf isl-0.12.2.tar.bz2 && cd isl-0.12.2
./configure
make
make install

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

#===================================================================================================

#llvm-clang

#Checkout LLVM:
#Change directory to where you want the llvm directory placed.
mkdir /Data/software/llvm-clang && cd  /Data/software/llvm-clang
svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm

# Checkout Clang:
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang

# Checkout extra Clang Tools: (optional)
cd llvm/tools/clang/tools
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra

# Checkout Compiler-RT:
cd llvm/projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
cd ../../

#Build LLVM and Clang:
mkdir build
cd build
../llvm/config --enable-optimized  #会提示gcc版本过低，升级gcc方法见gcc/install.sh
make -j4
make install

#clang加入系统变量
export PATH=/usr/local/bin:$PATH 
echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig

#安装clang标准库
cd /Data/software/llvm-clang/llvm
svn co http://llvm.org/svn/llvm-project/libcxx/trunk libcxx
cd libcxx/lib
./buildit
cp -r ../include/ /usr/include/c++/v1/
ln -s libc++.so.1.0 libc++.so.1
ln -s libc++.so.1.0 libc++.so
cp libc++.so* /usr/lib/

cd /Data/software/llvm
svn co http://llvm.org/svn/llvm-project/libcxxabi/trunk libcxxabi
cd libcxxabi/lib
./buildit
cp -r ../include/ /usr/include/c++/v1/
ln -s libc++abi.so.1.0 libc++abi.so.1
ln -s libc++abi.so.1.0 libc++abi.so
cp libc++abi.so* /usr/lib/

#================================================================================================

# 安装vundel，vim插件管理器
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# 使用vundel安装YouCompleteMe

# 在.vimrc中添加如下内容：

""""""""""""""""""""""""""""""  
" Vunble  
""""""""""""""""""""""""""""""  
filetype off " required!  
set rtp+=~/.vim/bundle/vundle/  
call vundle#rc()  
  
" let Vundle manage Vundle  
Bundle 'gmarik/vundle'  
  
" YouCompleteMe repos  
Bundle 'Valloric/YouCompleteMe'  
  
filetype plugin indent on " required!

# 执行命令 vim +BundleInstall +qall来安装YouCompleteMe

# 编译YouCompleteMe

cd ~
mkdir ycm_build
cd ycm_build
cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/cpp
cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=/usr/ . ~/.vim/bundle/YouCompleteMe/cpp
make ycm_core 
make ycm_support_libs
#make 结果是在~/.vim/bundel/YouCompletMe/python目录下生成libclang.so、ycm_core.so、ycm_client_support.so

#安装 YouCompleteMe
cd ~/.vim/bundle/YouCompleteMe 

./install.sh --clang-completer --system-libclang 

