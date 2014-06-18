#nginx+thinkphp,开启pathinfo

#thinkphp的URL_MODEL=>1

#nginx的PATHINFO配置


# rewrite规则，将请求转给入口文件index.php
location / {
        if (!-e $request_filename){
            rewrite ^/(.*)$ /index.php?s=$1 last;
        }
    }

#如果Thinkphp安装在子目录，rewrite规则部分需要做相应修改：

location /wap/datai/admin {
        if (!-e $request_filename){
            rewrite ^/wap/datai/admin/(.*)$ /wap/datai/admin/index.php?s=$1 last;
        }
    }

# pathinfo开启
location ~ .*\.(php|php5)
    {
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_split_path_info ^(.+\.php)(.*)$;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
	
	
#旧版本nginx的pathinfo这样开启：

location ~ \.php {
        set $script $uri;
        set $path_info "";

        if ($uri ~ "^(.+.php)(/.+)") {
                set $script $1;
                set $path_info $2;
        }

        fastcgi_pass  unix:/tmp/www.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$script;
        fastcgi_param SCRIPT_NAME $script;
        fastcgi_param PATH_INFO $path_info;
        include fastcgi_params;
       }
