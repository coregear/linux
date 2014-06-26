上传脚本和模版

脚本检测

 ./get_nginx_clients_status.pl http://172.16.83.162/nginx_status/  #其中的Ip为被监控端

可能提示缺少perl的LWP::UserAgent模块，先添加模块

perl -MCPAN -e shell

cpan[1]> install LWP::UserAgent


被监控端打开nginx的stub_status

location /nginx_status/ {

stub_status on;
accesslog off;
allow xxx;
deny all;
}