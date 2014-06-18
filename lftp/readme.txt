#在用lftp访问国内一些ftp服务器时，往往看到的中文是乱码,这是由于服务器和本地编码不一致造成的。我们只要在主目录下新建一个文件~/.lftprc或者~/.lftp/rc,并在其中加入以下内容：

debug 3
set ftp:charset GBK
set file:charset UTF-8
#set ftp:passtive-mode no
#alias utf8 " set ftp:charset UTF-8"
#alias gbk " set ftp:charset GBK"

# lftp连接方式
lftp -u username,passwd -p 21 ftp.exam.com
lftp username:passwd@ftp.exam.com:port
lftp ftp://user:passwd@exam.com:port
lftp sftp://user:passwd@exam.com:port
lftp username@exam.com:port


#lftp连接使用ssl加密

lftp
lftp :~> set ftp:ssl-force yes
lftp :~> set ssl:verify-certificate no # 如果证书是受信任的，略过此步骤
lftp :~> connect username@exam.com:port
#也可直接将这两个变量写到~/.lftp/rc中,但是一旦写入rc中就成为全局配置，将无法连接不支持ssl的ftp服务器.


#bookmark
#显示所有书签
bookmark

#添加书签
bookmark add  66.53  ftp://www@10.10.66.53:21220

#删除
bookmark del 66.53

#使用书签
lftp 66.53



