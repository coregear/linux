#主要参数

-x  (–max-connection-per-server ),多线程下载，对每个服务器使用几个连接

aria2c -x2 http://host/image.iso #使用2个线程下载这个文件




-s 使用多个链接下载同一文件

aria2c -s2 http://host/image.iso http://mirror1/image.iso http://mirror2/image.iso
#可以指定URIs的数量多余 -s 选项设定的数。在这个例子中，前两个URL会被用于下载，而第三个URL作为备用（如果前面两个有个挂了，第三个顶上）


-u  (–max-upload-limit) 最大上传速度
-c  断点续传

-S 查看种子中包含的文件
--select-file 选择要下载种子中的哪些文件
aria2c --select-file=1-4,8 file.torrent

