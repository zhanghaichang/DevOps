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
