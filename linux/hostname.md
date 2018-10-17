## CentOs7.3 修改主机名

### 第一种 临时的主机名
```
 hostname <hostname>

 $ hostname node1  
```
这种方式，只能修改临时的主机名，当重启机器后，主机名称又变回来了。

### 第二种
```
 hostnamectl set-hostname <hostname>

 $ hostnamectl set-hostname node1

 $ reboot
```
## CentOs6.5 修改主机名

### 1.修改network文件

* 修改HOSTNAME的值，改为要修改主机名

```shell
$ vi /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=node1
```

### 2.修改hosts文件
```
> $ vi /etc/hosts

> 127.0.0.1 hostname
```
