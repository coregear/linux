附：samba常用参数

comment: 对共享目录的备注
path：共享的路径。
allow hosts和deny hosts：允许或者拒绝的主机
writeable：目录缺省是否可写，也可以用readonly = no来设置可写
valid users：能够使用该共享资源的用户和组
invalid users：不能够使用该共享资源的用户和组
read list：只能读取该共享资源的用户和组
write list：能读取和写该共享资源的用户和组
admin list：能管理该共享资源（包括读写和权限赋予等）的用户和组
public：该共享资源是否能给游客帐号访问，这个开关有时候也叫guest ok
hide dot files：是否隐藏以“.”号开头的文件
create mode：新建立的文件的属性，一般是0644
directory mode：新建立的目录的属性，一般是0755
sync always：对该共享资源进行写操作后是否进行同步操作
short preserve case：不管文件名大小写
preserve case：保持大小写

case sensitive：是否对大小写敏感，一般选no,不然可能引起错误
mangle case：指明混合大小写
default case：缺省的文件名是全部大写还是小写（lower/upper）
force user：强制制定新建立文件的属主
wide links：是否允许共享链接文件
max connections = n：设定同时连接数
delete readonly:能否删除共享资源里面已经被定义为只读的文件。




comment = Share //定义共享目录名称，可用任意字符串 
path = /home/share //设定共享目录路径 
public = no //指定该共享是否允许guest账户访问 
available = yes //用来指定该共享资源是否可用 
admin users = itadmin //指定该共享的管理员，对该共享具有完全控制权限，如果用户验证方式设置成“security=share”时，此项无效。 
valid users = +mgr,+periphery,+filemgr //用来指定允许访问该共享资源的用户，单个用户就直接写用户名，组就是“+组名” 
writable = yes //是否允许写入，这项对下面的几项来说是首选，这项设置为NO，下面的create mask directory mask 等一系列预设值无效 
write list = +mgr,+periphery,+filemgr //指定在该共享下有写入权限的用户 
create mask= 0755 //表示新建文件的预设值，文件所有者全部权限，组内用户及其他用户可读可执行 
directory mask= 0755 //表示新建目录的预设值，目录所有者全部权限，组内用户及其他用户可读可执行 
browseable = no //指定该共享是否可以浏览 
