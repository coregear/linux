#apache/tomcat安装过程略

##一些变量###

#apache安装目录
APACHE_PREFIX=/Data/app/apache

#apache配置文件
APACHE_CONF=/etc/httpd/httpd.conf

#tomcat 安装目录
TOMCAT1_PREFIX=/Data/app/tomcat1
TOMCAT2_PREFIX=/Data/app/tomcat2
#tomcat根目录
TOMCAT_ROOT=/Data/code


# 为tomcat添加项目，也就是配置tomcat根目录,修改$TOMCAT_PREFIX/conf/server.xml
# 在<Host></Host>段添加Context,这里设置为/Data/code/
<Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
<Context path="" docBase="/Data/code"></Context>
.....
.....
</Host>


#jk安装（apache tomcat 连接器）

wget  http://archive.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.39-src.tar.gz

tar zxvf tomcat-connectors-1.2.39-src.tar.gz && cd tomcat-connectors-1.2.39-src/native

./configure --with-apxs=/Data/app/apache/bin/apxs --with-java-home=/Data/app/jdk

make # mod_jk.so会生成在apache安装目录下的modules目录


#安装tomcat native，否则在tomcat启动日志中会有关于libnative的报错

cd /Data/app/tomcat/bin  # tomcat 安装目录下的bin目录

tar zxvf tomcat-native.tar.gz && cd tomcat-native-1.1.29-src/jni/native

./configure --with-apr=/Data/app/apr/bin/apr-1-config --with-ssl=/usr/local/ssl/

make && make install

cp  /usr/local/apr/lib/libtcnative* /usr/lib  #拷贝到/usr/lib  /usr/lib64等位置都可，参考tomcat启动日志



#启动多个tomcat，本机启动多个tomcat，要注意修改tomcat端口，server.xml的8080,8005,8009端口都要避免冲突，不然无法启动多个tomcat

#假设本机安装的两个tomcat分别为$TOMCAT1_PREFIX和$TOMCAT2_PREFIX,确认端口无冲突后启动
$TOMCAT1_PREFIX/bin/catalina.sh start
$TOMCAT2_PREFIX/bin/catalina.sh start

#配置apache作为前端，将请求转发给后端tomcat集群

#在/etc/httpd/extra目录下创建mod_jk.conf,文件内容为：

LoadModule jk_module modules/mod_jk.so  #加载mod_jk模块
JkWorkersFile /etc/httpd/extra/workers.properties  #这个文件里配置的是tomcat集群及负载均衡
JkMountFile /etc/httpd/extra/uriworkermap.properties  # 这里配置的是转发规则，即哪些由apache自己处理，哪些交给tomcat
JkLogFile logs/mod_jk.log
JkLogLevel info

#在extra下创建workers.properties和uriworkermap.properties

####################################
##file name workers.properties####
worker.list=tomcatserver,status  # tomcatserver为均衡器名称，自定义
# localhost server 1
# ------------------------
worker.s1.port=8009       #s1是为tomcat定义的名称，多个tomcat不得冲突
worker.s1.host=localhost
worker.s1.type=ajp13
worker.s1.lbfactor = 1    #在集群中的权重
# localhost server 2
# ------------------------
worker.s2.port=8010       #s2的意义同s1
worker.s2.host=localhost
worker.s2.type=ajp13
worker.s2.lbfactor = 1

#-----------------------------
worker.tomcatserver.type=lb   #负载均衡类型，
worker.retries=3
worker.tomcatserver.balance_workers=s1,s2   #s1,s2就是上边定义的名称
worker.tomcatserver.sticky_session=false  #启用session复制，该选项必须为false,如果为true，则表示同一用户的请求不会在多个tomcat之间移动，固定由一个tomcat处理
worker.tomcatserver.sticky_session_force=1 #默认tomcat 无反应，是否将请求转到其他tomcat
worker.status.type=status




##########################################
#####file name uriworkermap.properties####
/*=tomcatserver             #所有请求都由controller这个server处理
/jkstatus=status           #所有包含jkstatus请求的都由status这个server处理
!/*.gif=tomcatserver         #所有以.gif结尾的请求都不由tomcatserver这个server处理，以下几个都是一样的意思
!/*.jpg=tomcatserver
!/*.png=tomcatserver
!/*.css=tomcatserver
!/*.js=tomcatserver
!/*.htm=tomcatserver
!/*.html=tomcatserver


#修改$APACHE_CONF，

Include /etc/httpd/extra/mod_jk.conf

#重启httpd

#现在apache已经可以使用jk方式与tomcat通信，并且将请求平均分发给s1,s2两个tomcat.不安装jk的话,apache可以使用proxy方式与tomcat通信


#多个tomcat session复制,保持客户端会话

# 修改$TOMCAT1_PREFIX/conf/server.xml和$TOMCAT2_PREFIX/conf/server.xml

#####TOMCAT1_PREFIX/conf/server.xml######

<Engine name="Catalina" defaultHost="localhost" jvmRoute="s1">  #jvmRoute必须设置，s1与workers.properties中设置的名称一致，另一个为jvmRoute="s2"

      <!--For clustering, please take a look at documentation at:
          /docs/cluster-howto.html  (simple how to)
          /docs/config/cluster.html (reference documentation) -->
      <!--
      <Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"/>
      -->

        <Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
                 channelSendOptions="8">

          <Manager className="org.apache.catalina.ha.session.DeltaManager"
                   expireSessionsOnShutdown="false"
                   notifyListenersOnReplication="true"/>

          <Channel className="org.apache.catalina.tribes.group.GroupChannel">
            <Membership className="org.apache.catalina.tribes.membership.McastService"
                        address="228.0.0.4"
                        port="45564"
                        frequency="500"
                        dropTime="3000"/>
<Receiver className="org.apache.catalina.tribes.transport.nio.NioReceiver"
                      address="auto"      #auto的话，会绑定在127.0.0.1上
                      port="4000"         #这个端口号两个tomcat必须不一致，不得冲突
                      autoBind="100"
                      selectorTimeout="5000"
                      maxThreads="6"/>

            <Sender className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
              <Transport className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"/>
            </Sender>
            <Interceptor className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"/>
            <Interceptor className="org.apache.catalina.tribes.group.interceptors.MessageDispatch15Interceptor"/>
          </Channel>

          <Valve className="org.apache.catalina.ha.tcp.ReplicationValve"
                 filter=""/>
          <Valve className="org.apache.catalina.ha.session.JvmRouteBinderValve"/>

          <Deployer className="org.apache.catalina.ha.deploy.FarmWarDeployer"
                    tempDir="/tmp/war-temp/"
                    deployDir="/tmp/war-deploy/"
                    watchDir="/tmp/war-listen/"
                    watchEnabled="false"/>
					<ClusterListener className="org.apache.catalina.ha.session.JvmRouteSessionIDBinderListener"/>
          <ClusterListener className="org.apache.catalina.ha.session.ClusterSessionListener"/>
        </Cluster>


# 在$TOMCAT_ROOT下创建WEB-INF目录，WEB-INF目录下创建web.xml

<web-app xmlns="http://java.sun.com/xml/ns/javaee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
                      http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
  version="3.0"
  metadata-complete="true">

  <display-name>Welcome to Tomcat</display-name>
  <description>
     Welcome to Tomcat
  </description>
<distributable/>    #必须添加这个标签
</web-app>


# 启动两个tomcat

		
		
route add -net 224.0.0.0 netmask 240.0.0.0 dev eth0