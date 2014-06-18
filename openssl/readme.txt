#openssl升级
wget  http://www.openssl.org/source/openssl-1.0.1g.tar.gz



tar zxvf openssl-1.0.1g.tar.gz
cd openssl-1.0.1g
./config shared zlib
make
make install
mv /usr/bin/openssl /usr/bin/openssl.OFF
mv /usr/include/openssl /usr/include/openssl.OFF
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl

