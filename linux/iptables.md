# CentOS7.3 安装 iptables 与详细使用

## 安装操作

### 检查状态

先检查是否安装了iptables
 
```sh
$ service iptables status
```

### 安装iptables

```sh
$ yum install iptables
```

### 升级iptables

```sh
$ yum update iptables 
```

### 安装iptables-services

```sh
$ yum install iptables-services
```

### 编辑配置

```sh
$ vi /etc/sysconfig/iptables-config
```

### 添加配置

 -  示例：开放RabbitMQ 的 对外端口

```sh
iptables -I INPUT -p tcp --dport 5672 -j ACCEPT
iptables -I INPUT -p tcp --dport 15672 -j ACCEPT
```

### 保存配置

```sh
$ service iptables save
```

**更多操作请往下阅读**

### 重启服务

```sh
systemctl restart iptables.service
```

## 更多详细配置规则

### 编辑配置
```sh
$ vi /etc/sysconfig/iptables-config
```

### 规则操作

查看iptables现有规则
```sh
iptables -L -n
```

允许所有
```sh
iptables -P INPUT ACCEPT
```

允许IO访问

允许来自于lo接口的数据包(本地访问)

```sh
iptables -A INPUT -i lo -j ACCEPT
```

开放443端口(TCP)

```sh
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```

开放443端口(FTP)

```sh
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```

开放80端口(HTTP)

```sh
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

开放443端口(HTTPS)

```sh
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```

允许ping

```sh
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
```

允许响应

允许接受本机请求之后的返回数据 RELATED,是为FTP设置的

```sh
iptables -A INPUT -m state --state  RELATED,ESTABLISHED -j ACCEPT
```

入站一律丢弃

```sh
iptables -P INPUT DROP
```

出站全部允许

```sh
iptables -P OUTPUT ACCEPT
```

转发一律丢弃

```sh
iptables -P FORWARD DROP
```

## 更多常用命令操作

清除规则

 - 清除已有iptables规则
 
```sh
iptables -F #清空所有默认规则
iptables -X #清空所有自定义规则
iptables -Z #所有计数器归0
```

保存配置

```sh
$ service iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
```

开启服务

```sh
$ systemctl start  firewalld
```

检查状态
 
```sh
$ service iptables status
```

停止服务

```sh
$ systemctl stop firewalld
```

重启服务

```sh
$ systemctl restart iptables.service
```

查看规则

```sh
iptables -L -n
```
 - v：显示详细信息，包括每条规则的匹配包数量和匹配字节数
 - x：在 v 的基础上，禁止自动单位换算（K、M） vps侦探
 - n：只显示IP地址和端口号，不将ip解析为域名

标记显示

 - 将所有iptables以序号标记显示
 
```sh
$ iptables -L -n --line-numbers
Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination         
1    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:15672
2    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:5672
```

删除规则

 - 比如要删除INPUT里序号为1的规则
 
```sh
iptables -D INPUT 1
```

禁用服务

```sh
$ systemctl mask firewalld
```

开机启动

```sh
systemctl enable iptables.service 
```
