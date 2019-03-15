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


