#试验环境 Centos5.6,最高可使用2.6.38，版本再高则无法编译通过####

###在CentOS6.4上2.6.40可以编译通过，应该是已内核版本2.6.23为界####
##download from  https://download.openswan.org/openswan/ ####

###deps#####
yum install gmp-devel flex bison-devel

tar zxvf openswan-2.6.38.tar.gz && cd openswan-2.6.38 && make programs && make install

ipsec --version
Linux Openswan U2.6.38/K(no kernel code presently loaded)
See `ipsec --copyright' for copyright information.



