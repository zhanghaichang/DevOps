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
useradd -d /usr/username -m username

为用户增加密码：passwd username

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
