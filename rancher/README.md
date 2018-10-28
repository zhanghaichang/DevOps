# rancher 2.0安装

```
vim /etc/sysconfig/docker
 remove --selinux-enabled from the OPTIONS variable

sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
```

### 稳定版本
```
sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:stable
```

### 关闭防火墙 


```
systemctl disable firewalld

systemctl stop firewalld

```

### 安装 开启 Iptables  

[iptables 安装教程](/linux/iptables.md)


