### centos压缩和解压缩命令之zip

常见压缩格式： 
.zip 
.gz 
.bz2 
.tar.gz 
.tar.bz2

在Linux系统中使用压缩命令时，发现压缩命令未找到，那么需要安装相关命令 
在centOS中 可以用yum命令安装

yum -y install 包名（支持*） ：自动选择y，全自动,安装过程中不会询问 
yum install 包名（支持*） ：手动选择y or n 
yum remove 包名（不支持*） 
rpm -ivh 包名（支持*）：安装rpm包 
rpm -e 包名（不支持*）：卸载rpm包

如 yum -y install zip

zip 压缩文件 
格式：zip 压缩文件名 源文件 
安装命令：yum -y install zip 
例如： 
[root@localhost ~]# zip 123.zip 123 
adding: 123 (stored 0%) 
[root@localhost ~]# ll 
总用量 8 
-rw-r–r–. 1 root root 0 1月 14 14:14 123 
-rw-r–r–. 1 root root 156 1月 14 14:21 123.zip

zip 压缩目录 
格式：zip -r 压缩文件名 源目录 
-r 选项指定你想递归地（recursively）包括所有包括在 filesdir 目录中的文件 
不使用-r 只是把目录编程压缩包 目录里面的内容不会打包进去 
例如： 
[root@localhost ~]# zip -r we.zip we 
[root@localhost ~]# ll 
drwxr-xr-x. 2 root root 6 1月 13 16:25 we 
-rw-r–r–. 1 root root 156 1月 14 14:26 we.zip

zip解压 
格式：unzip 压缩文件 
例如： 
[root@localhost ~]# unzip we.zip
--------------------- 
 
