http://apr.apache.org/download.cgi

https://subversion.apache.org/download/

#install sqlite (version>= 3.7.12)

wget http://www.sqlite.org/2013/sqlite-autoconf-3080100.tar.gz

tar zxvf sqlite-autoconf-3080100.tar.gz && cd sqlite-autoconf-3080100

./configure --prefix=/usr && make && make install