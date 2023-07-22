### 一、Linux中用户和用户组
1.用户简介
超级用户：root 用户是 Linux 操作系统中默认的超级用户账号，对本主机拥有最高的权限。系统中超级用户是唯一的。

普通用户：由root用户或其他管理员用户创建，拥有的权限会受到限制，一般只在用户自己的宿主目录中拥有完整权限。

程序用户：在安装Linux操作系统及部分应用程序时，会添加一些特定的低权限用户账号，这些用户一般不允许登录到系统，仅用于维持系统或某个程序的正常运行，如 bin、daemon、ftp、mail 等。

UID：用户标识号

超级用户：默认为0

普通用户：500-66666（centos 6之前）；1000-66666（centos 7以后）

程序用户：1-499（centos 6之前）；1-999（centos 7以后）

2.组简介
基本组（私有组）：基本组账号只有一个，一般为创建用户时指定的组。

附加组（公共组）：用户除了基本组以外，额外添加指定的组，可有可无，可以有多个

GID:组标识号

超级用户：默认为0

普通用户：500-60000（centos 6之前）；1000-60000（centos 7以后）

程序用户：1-499（centos 6之前）；1-999（centos 7以后）

### 二、用户和用户组配置文件
1.用户账号文件：/etc/passwd
基于系统运行和管理需要，所有用户都可以访问passwd文件中的内容，但是只有root用户才能进行更改。在早期的UNIX操作系统中，用户帐号的密码信息是保存在passwd文件中的，不法用户可以很容易的获取密码字串并进行暴力破解，因此存在一定的安全隐患。后来经改进后，将密码转存入专门的shadow文件中，而passwd文件中仅保留密码占位符“x”。

root:x:0:0:root:/root:/bin/bash

字段1：用户帐号的名称
字段2：用户密码占位符“x”
字段3：用户帐号的UID号
字段4：所属基本组帐号的GID号
字段5：用户全名
字段6：宿主目录
字段7：登录Shell信息（/bin/bash为可登陆系统，/sbin/nologin和/bin/false为禁止用户登陆系统）


## 查看centos中的用户和用户组

 ```
用户列表文件：/etc/passwd
用户组列表文件：/etc/group

查看系统中有哪些用户：cut -d : -f 1 /etc/passwd
查看可以登录系统的用户：cat /etc/passwd | grep -v /sbin/nologin | cut -d : -f 1
查看用户操作：w命令(需要root权限)
查看某一用户：w 用户名
查看登录用户：who
查看用户登录历史记录：last
```

## 添加用户
```
useradd test

useradd -d /usr/username -m username

为用户增加密码：passwd username

默认情况下，useradd命令将在/home路径中创建一个与用户名同名的主目录，
```

## 删除用户
```
userdel username

```

## 添加组别

```
groupadd groupname
```
## 删除组

```
groupdel groupname
```

## 将用户添加进工作组
```
usermod -G groupname username
```


## Linux用户密码期限修改


先重置用户密码，发现过期日志为Oct 08, 2017，有效期为90天。

```
[root@01 ~]# chage -l testuser
Last password change     : Jul 10, 2017
Password expires     : Oct 08, 2017
Password inactive     : never
Account expires     : never
Minimum number of days between password change     : 0
Maximum number of days between password change     : 90
Number of days of warning before password expires    : 10
```
修改密码为永不过期，修改后见红色标注

```
[root@01 ~]# chage -M 99999 testuser
[root@01 ~]# chage -l testuser
Last password change                    : Jul 10, 2017
Password expires                    : never
Password inactive                    : never
Account expires                        : Oct 16, 2243
Minimum number of days between password change        : 0
Maximum number of days between password change        : 99999
Number of days of warning before password expires    : 10
```

如果账户设置过了过期时间，后面新加的用户都会受到这个设置的影响

这个主要是由/etc/login.defs参数文件中的一些参数控制的的。它主要用于用户账号限制
```
PASS_MAX_DAYS 90
PASS_MIN_DAYS	0
PASS_MIN_LEN	6
PASS_WARN_AGE	10
```
