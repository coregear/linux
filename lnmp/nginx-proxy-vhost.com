server {
	listen 80;
	server_name www.phpchina.com phpchina.com;
	if ($host != 'www.phpchina.com'){
 		rewrite ^/(.*) http://www.phpchina.com/$1 permanent;
 	}
	access_log off;
	if  ( $fastcgi_script_name ~ \..*\/.*php )  {
                 return 403;
        }

    #目录后自动添加“/”
    if (-d $request_filename){
        rewrite ^/(.*)([^/])$ http://$host/$1$2/ permanent;
    }
    
	location / {
                proxy_set_header   Host   $host;
                proxy_set_header   X-Real-IP  $remote_addr;
				proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_pass http://192.168.122.110;
        }
}	
