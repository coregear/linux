#安装perl
wget http://www.cpan.org/src/5.0/perl-5.18.0.tar.gz 
tar zxvf perl-5.18.0.tar.gz
cd perl-5.18.0
./Configure -des -Dprefix=/usr/local/perl
make
make test
make install
#替换旧版本的perl
mv /usr/bin/perl /usr/bin/perl.old
ln -s /usr/local/perl/bin/perl /usr/bin/perl
#安装结果测试
perl -v

#psad需要以下perl模块，默认并未安装，需手动添加
Date::Calc
IPTables::Parse
Net::IPv4Addr
IPTables::ChainMgr
Unix::Syslog
#为perl添加模块
perl -MCPAN -e shell #进入CPAN
cpan> reload cpan #更新cpan
cpan> install <模块名>

#安装psad
tar psad-2.2.tar.bz2
cd psad-2.2
./install.pl #安装过程中会提示输入用来接收报警邮件的email、系统中syslog守护进程类型（syslog/syslog-ng等）等信息
cp signatures /etc/psad/
