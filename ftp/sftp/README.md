##  linux SFTP用户创建 不允许用户登录，并且连接只允许在制定的目录下进行操作

### 1.创建用户
```
groupadd sftp
```

### 2.添加用户并设置为sftp组

```
 useradd -g sftp -s /sbin/nologin -M sftp    （/sbin/nologin为禁止登录shell的用户）
```

### 3.设置用户密码
```
passwd sftp
```

### 4.创建用户目录。并设置权限。
```
cd /home

mkdir sftp

chown root:sftp sftp

chmod 755 sftp
```
### 5.修改SSH配置


```
vim /etc/ssh/sshd_config

#该行(上面这行)注释掉
#Subsystem sftp /usr/lib/openssh/sftp-server
 
# 添加以下几行
Subsystem sftp internal-sftp 
Match group sftp
#Match user test
#匹配sftp组，如为单个用户可用：Match user 用户名;  设置此用户登陆时的shell设为/bin/false,这样它就不能用ssh只能用sftp
ChrootDirectory /home/test
#指定用户被锁定到的那个目录，为了能够chroot成功，该目录必须属主是root，并且其他用户或组不能写
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp

```

### 6.最后重启SSH
```
/etc/init.d/ssh restart
```


### 测试

```
[root@localhost etc]# sftp test@172.19.194.30
test@172.19.194.30's password: 
Connected to 172.19.194.30.
sftp> ls
a                a.log            authorized_keys  mysql.sh         
sftp>

```
