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
/etc/ssh/sshd_config

修改Subsystem

Subsystem sftp internal-sftp
```
### 6.在sshd_config添加用户配置
```
Match User sftp   #限制的用户

X11Forwarding no  

AllowTcpForwarding no

ForceCommand internal-sftp

ChrootDirectory /home/sftp  #用户的根目录
```

### 7.最后重启SSH
```
/etc/init.d/ssh restart
```
