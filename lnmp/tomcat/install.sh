#jave-jdk

#http://www.oracle.com/technetwork/java/javase/downloads/index.html

chmod  +x  jdk-6u37-linux-x64.bin

./jdk-6u37-linux-x64.bin #安装完成后将生成jdk1.6.0_37目录

mv  jdk1.6.0_37  /usr/local/

#修改环境变量
#最好不要直接修改/etc/profile文件，而是通过修改用户家目录下的.bashrc文件来单独为制定用户设置环境变量

echo -ne "JAVA_HOME=/usr/local/jdk1.6.0_37\nPATH=$PATH:$JAVA_HOME/bin\nCLASSPATH=.:JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar\nexport JAVA_HOME PATH CLASSPATH" >> .bashrc

#测试是否安装成功
java -version

#tomcat

#http://mirror.olnevhost.net/pub/apache/tomcat/tomcat-7/v7.0.33/bin/apache-tomcat-7.0.33.tar.gz

tar zxvf apache-tomcat-7.0.33.tar.gz  

mv tar zxvf apache-tomcat-7.0.33  /usr/local/tomcat

$tomcat_home/bin/startup.sh | shutdown.sh 

#修改tomcat根目录

$tomcat_home/conf/server.xml
<Host name="localhost"  appBase="webapps" unpackWARs="true" autoDeploy="true">
<Context path="" docBase="/data/www/zhonggong/bbs" debug="0" reloadable="true" crossContext="true" /> #这一句是自行添加的
