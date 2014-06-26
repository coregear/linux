#修改tomcatstats.pl
my $url = "http://$username:$password"."\@$host/manager/status?XML=true";
my $xml = `GET $url`;

以上两行修改为如下内容：
my $url = "http://$host/manager/status?XML=true";
my $xml = `wget -qO - --http-user=$username --http-password=$password $url`;

# tomcatstats.pl上传到cacti_path/scripts目录下，并赋予执行权限


#从cacti控制台导入模版cacti_host_template_tomcat_server.xml

#修改tomcat_path/conf下的tomcat-users.xml,添加如下内容

<tomcat-users>
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<user username="admin" password="happigo" roles="manager-gui,manager-script,manager-jmx,manager-status"/>
</tomcat-users>   

#在tomcat控制台中点击"数据输入方法" 找到"Tomcat Status"(这是刚才导入的tomcat模版所使用的数据输入方法)，输入类型修改为：
perl <path_cacti>/scripts/tomcatstats.pl <hostname>:8080 admin happigo \"http-bio-8080\"  #http-bio-8080相当于tomcat提供的一个接口，用来获取tomcat运行状况，接口名称不一定是http-bio-8080,可通过http://ip:port/manager/status?XML=true来查看

#如果监控一台机器上多个tomcat实例，或者多台机器上的tomcat，因为端口和接口名称不一定相同，所以需要手动添加数据模版，然后给每个模版添加合适的数据输入方法才行。
