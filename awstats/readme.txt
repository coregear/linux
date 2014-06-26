
awstats+nginx:

工作逻辑：

1 处理nginx访问日志，按天进行切割，存储到相应目录

2 修改aws配置文件，指定LogFile，也就是第一步切割好的日志，aws将会对该日志进行分析处理

3  运行/usr/local/awstats/tools/awstats_buildstaticpages.pl -update -config=bbs.phpchina.com -lang=cn -dir=/backup/www/awstats/bbs.phpchina.com -awstatsprog=/usr/local/awstats/wwwroot/cgi-bin/awstats.pl ，对每天的日志进行分析，并生成html文件。

4 http访问html文件

5 可以使用计划任务将1、3自动化

范例：
#nginx配置文件
# aws.phpchina.com
server {
    listen      80;
    server_name aws.phpchina.com;
    index           index.html;
    root            /backup/www/awstats/bbs.phpchina.com;
    access_log  off;
     if  ( $fastcgi_script_name ~ \..*\/.*php )  {
                 return 403;
        }

    location / {
    auth_basic "auth";
    auth_basic_user_file /backup/www/awstats/bbs.phpchina.com/htpasswd;
    autoindex       on;
    }
    location /icon/ {
    alias /usr/local/awstats/wwwroot/icon/;
    index index.html;
    access_log off;
    }
}

aws配置文件，主要修改LogFile参数，其他保持默认即可。


多日志合并分析(例：30.0206.vblog.log与31.0206.vblog.log)
LogFile="/opt/awstats/tools/logresolvemerge.pl /var/apachelogs/30.0206.vblog.log /var/apachelogs/31.0206.vblog.log|"
或
LogFile="/opt/awstats/tools/logresolvemerge.pl /var/apachelogs/*.0206.vblog.log|"

(2)分析使用gzip压缩过的日志文件
LogFile="gzip -d </var/log/apache/access.log.gz|"

awstats+apache:

tar zxvf awstats-6.6.tar.gz
mv awstats-6.6 awstats
cd awstats/tools/
perl awstats_configure.pl


3、Perl脚本awstats_configure.pl安装过程(以下内容引用AWStats英文使用说明)

(1)
-----> Running OS detected: Linux, BSD or Unix
Warning: AWStats standard directory on Linux OS is '/usr/local/awstats'.
If you want to use standard directory, you should first move all content
of AWStats distribution from current directory:
/opt/awstats
to standard directory:
/usr/local/awstats
And then, run configure.pl from this location.
Do you want to continue setup from this NON standard directory [yN] ?

这时选择y回车。

(2)
-----> Check for web server install

Enter full config file path of your Web server.
Example: /etc/httpd/httpd.conf
Example: /usr/local/apache2/conf/httpd.conf
Example: c:\Program files\apache group\apache\conf\httpd.conf
Config file path ('none' to skip web server setup):

第一次使用请输入Apache的httpd.conf路径，例如/opt/sina/apache/conf/httpd.conf
以后如果再使用perl awstats_configure.pl生成配置文件，则可以输入none跳过。

(3)
-----> Check and complete web server config file '/opt/sina/apache/conf/httpd.conf'
Warning: You Apache config file contains directives to write 'common' log files
This means that some features can't work (os, browsers and keywords detection).
Do you want me to setup Apache to write 'combined' log files [y/N] ?

选择y，将日志记录方式由CustomLog /yourlogpath/yourlogfile common改为更详细的CustomLog /yourlogpath/yourlogfile combined

(4)
-----> Update model config file '/opt/awstats/wwwroot/cgi-bin/awstats.model.conf'
 File awstats.model.conf updated.

-----> Need to create a new config file ?
Do you want me to build a new AWStats config/profile
file (required if first install) [y/N] ?

创建一个新的配置文件，选择y

(5)
-----> Define config file name to create
What is the name of your web site or profile analysis ?
Example: www.mysite.com
Example: demo
Your web site, virtual server or profile name:
>
输入站点名称，例如xxxx

(6)
-----> Define config file path
In which directory do you plan to store your config file(s) ?
Default: /etc/awstats
Directory path to store config file(s) (Enter for default):
>

输入AWStats配置文件存放路径，一般直接回车则使用默认路径/etc/awstats

(7)
-----> Add update process inside a scheduler
Sorry, configure.pl does not support automatic add to cron yet.
You can do it manually by adding the following command to your cron:
/opt/awstats/wwwroot/cgi-bin/awstats.pl -update -config=sina
Or if you have several config files and prefer having only one command:
/opt/awstats/tools/awstats_updateall.pl now
Press ENTER to continue...

按回车键继续

(8)
A SIMPLE config file has been created: /opt/awstats/etc/awstats.sina.conf
You should have a look inside to check and change manually main parameters.
You can then manually update your statistics for 'sina' with command:
> perl awstats.pl -update -config=sina
You can also read your statistics for 'sina' with URL:
> http://localhost/awstats/awstats.pl?config=sina

Press ENTER to finish...

按回车键结束


4、修改awstats.sina.conf配置
vi /etc/awstats/awstats.xxxx.conf

按?，在之后输入要搜索的内容LogFile="
然后按Ins键，找到LogFile="/var/log/httpd/access_log"
改为要分析的Apache日志路径与文件名。

(1)多日志合并分析(例：新浪播客其中两台服务器2月6日的日志30.0206.vblog.log与31.0206.vblog.log)
LogFile="/opt/awstats/tools/logresolvemerge.pl /var/apachelogs/30.0206.vblog.log /var/apachelogs/31.0206.vblog.log|"
或
LogFile="/opt/awstats/tools/logresolvemerge.pl /var/apachelogs/*.0206.vblog.log|"

(2)分析使用gzip压缩过的日志文件
LogFile="gzip -d </var/log/apache/access.log.gz|"


5、更新分析报告
perl /opt/awstats/wwwroot/cgi-bin/awstats.pl -config=xxxx -lang=cn -update

如果出现以下错误提示，很大可能是Apache的Log文件中存在以前CustomLog /yourlogpath/yourlogfile common生成的日志，删除掉这些行的日志即可：
This means each line in your web server log file need to have "combined log format" like this:
111.22.33.44 - - [10/Jan/2001:02:14:14 +0200] "GET / HTTP/1.1" 200 1234 "http://www.fromserver.com/from.htm" "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)"


6、查看分析报告
http://localhost/awstats/awstats.pl?config=xxx



7 安装插件
awstats自带GeoIP插件，只需要下载Geo的IP数据库并为服务器上的perl安装Geo::IP::PurePerl模块

修改awstats.xxx.conf

LoadPlugin="tooltips"
LoadPlugin="decodeutfkeys"
LoadPlugin="geoip GEOIP_STANDARD /path/GeoIP.dat"
LoadPlugin="geoip_city_maxmind GEOIP_STANDARD /path/GeoLiteCity.dat"

8 安装qqhostinfo插件

上传插件到awstats/wwwroot/cgi-bin/plugins目录

vi qqhostinfo.pm

push @INC, "/path/plugins"
require "/path/qqwry.pl"

vi qqwry.pl

my $ipfile="/path/qqwry.dat"


然后在配置文件中加载插件：
LoadPlugin="qqhostinfo"


#如果安装以后页面上"关键词"部分是乱码的话，需要打开awstats配置文件中的decodeutfkeys插件，用来处理UTF8编码数据，因为搜索引擎多使用UTF8格式
LoadPlugin="decodeutfkeys"” #打开这个插件的话可能需要perl安装了URI::Escape模块




###

页面访问是使用的配置文件名称要和update时使用的配置文件名称一致，不然会造成BUID生成的数据文件名和UPDATE试图读取的数据文件名不一致，造成页面所有数据为空

也就是，如果perl awstats.pl config=3g.happigo.com -update

那么页面访问时，http://host/awstats/awstats/pl?config=3g.happigo.com

如果perl awstats.pl config=awstats.3g.happigo.com.conf -update

那么页面访问时，http://host/awstats/awstats/pl?config=awstats.3g.happigo.com.conf