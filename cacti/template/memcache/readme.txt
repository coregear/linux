#首先在cacti服务器安装Python Client API
yum install python-setuptools

tar zxvf python-memcached-1.53.tar.gz

cd python-memcached-1.53

python setup.py install

#添加memcached.py到scripts下，并上传模版 

