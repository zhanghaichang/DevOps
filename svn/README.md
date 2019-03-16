# svn

版本控制一直是项目开发中必不可少的，不仅有利于代码管理，而且对项目团队协作开发有很大的帮助。目前比较流行的版本控制管理有GIT和SVN，它们都有各自的优缺点，具体使用哪一个还是要看个人的喜好，它们功能也都是大同小异。本篇博文讲述的就是在Linux下安装配置SVN。


### 安装步骤

```
yum install subversion 
```
### 检查是否安装成功

```
svnserve --version 
```
### 卸载 

```
# 另外在安装之前也可以检测是否已经安装过旧版本，可将旧版本卸载之后重新安装。
# 检查已安装版本
# rpm -qa subversion
# 卸载旧版本SVN
# yum remove subversion
```

### 恢复数据

将备份文件load进新服务器仓库

```
svnadmin load /usr/local/svnRepo/demo/ < /data/20180524.dump
```

使用scp命令，将源服务器上配置文件

```
scp -r /usr/local/svnRepo/demo/conf/ root@新服务器IP:/data/
```

### 添加用户


```
1、 找到svn安装路径  我的是 /home/ssl/repos/rogue_server/conf/ （如果不知道，可以搜索 ：find / -name svn）
2、进入该目录的conf，其中包含authz、passwd、svnserve.conf三个文件
3、进入passwd，在[users]下面加上你要添加的svn账号及密码   格式为：
[users]
liuzd=rogue_2016
fushan=rogue_2016
然后保存wq
（如果只增加用户，不用重启）
4、再进入authz，在[groups]下加上刚刚添加的用户名，格式为
[groups] 
www=liuzd,fushan
然后保存wq
5、重启svn
先kill掉svn进程：killall svnserve
启动svn：sudo svnserve -d -r /home/ssl/repos/
```

编辑cd /conf目录svnserve.conf主配置文件，对以下几项修改如下

```shell

[general]

anon-access = none    #取消匿名访问

auth-access = write    #授权用户有可写权限

password-db = passwd    #指定用户配置文件，后面会用到

authz-db = authz    #指定权限配置文件，后面会用到
```

### CollabNet Subversion 安装


配置开机启动[可选]
```
sudo bin/csvn-httpd install     #svn服务端
sudo -E bin/csvn install           #web页面
```

```
cd csvn/bin/
sh csvn start　　#启动
#如果使用start启动失败，可以使用下面的命令
sh csvn console　　#此命令会在控制台输出启动日志，便于确定是什么错误导致启动失败

#注意：如果确认已经安装JDK，但是程序依然提示没有找到。请配置如下
vim data/conf/csvn.conf
#在#JAVA_HOME下添加如下
JAVA_HOME="/usr/java/xxxx"   #/usr/java/xxxx是你自己的JDK路径
```
```
Address: http://localhost:3343/csvn
You can access the SSL version on this URL:
Address: https://localhost:4434/csvn
```


# SVN数据转移

一、旧服务器上要迁移的文件
```
1.1 拷贝csvn/data/repositories             　    (数据文件）

1.2 拷贝csvn/data/csvn-production-hsqldb.script     （用户配置文件）

1.3 拷贝csvn/data/conf/svn_auth_file              (用户列表文件)

1.4 拷贝csvn/data/conf/svn_access.file             (用户权限文件)
```

二、新服务器配置文件位置

```
2.1 数据文件                  /home/svn/csvn/data/repositories

2.2 用户配置文件            /home/svn/csvn/data/csvn-production-hsqldb.script

2.3 用户列表文件            /home/svn/csvn/data/conf/svn_auth_file

2.4 用户权限文件            /home/svn/csvn/data/conf/ svn_access.file
```

三、正式开始

```
3.1 首先，停止csvn 、csvn-httpd 服务  

3.2 先修改用户的文件，注意：旧的配置文件不能直接替换新服务器上的，
需要修改新服务器文件的内容，主要改用户列表和用户配置两个文件。

用户列表文件 svn_auth_file/

用户配置文件 csvn-production-hsqldb.script/

(主要修改  INSERT INTO USER VALUES 这部分，其中参数含义在下图.)

3.3数据文件、用户权限文件、这两个可以直接拷贝覆盖。

```

四、调整数据文件权限

```
4.1 chown –R svnroot:svn /xxxxxxxxxx
分别修改四个文件的属主、属组
```

五、启动
```

至此，修改完毕，启动csvn csvn-httpd 即可
     
```

保留版本记录方式:


目录下创建一个仓库 

```
svnadmin create  pzwg /usr/local/csvn/data/repositories
```
原仓库中dump库，新仓库中load
```
svnadmin dump /home/svn/csvn/data/repositories/projects > svn_bak

svnadmin load /opt/csvn/data/repositories/tr/ < /usr/svnbak/svn_bak
```
