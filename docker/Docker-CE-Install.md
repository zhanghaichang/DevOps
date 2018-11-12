# docker ce

### docker 一键在线安装
```
curl -s https://releases.rancher.com/install-docker/17.03.sh|sh
```

### SELINUX

安全增强型 Linux（Security-Enhanced Linux）简称 SELinux，它是一个 Linux 内核模块，也是 Linux 的一个安全子系统

```
sudo vi /etc/selinux/config

SELINUX=enforcing

改为SELINUX=disabled
```
重启机器即可


### 安装源
```
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

### 查询docker 版本
```
yum list docker-ce.x86_64  --showduplicates |sort -r
```

### 安装
```
yum makecache fast

yum install -y --setopt=obsoletes=0 \
  docker-ce-17.03.2.ce-1.el7.centos \
  docker-ce-selinux-17.03.2.ce-1.el7.centos
```

### 启动
```
systemctl start docker
systemctl enable docker
```

### docker命令不需要敲sudo的方法

1.创建一个docker组

```
$ sudo groupadd docker
```
2.添加当前用户到docker组

```
$ sudo usermod -aG docker $USER
```

3.登出，重新登录shell验证

```
$ docker info
```

### DaoCloud 镜像加速


#### 配置镜像加速地址
```
sudo vi /etc/docker/daemon.json

{
"registry-mirrors": ["https://7bezldxe.mirror.aliyuncs.com/"]
}

```

#### 配置insecure-registries私有仓库

Docker默认只信任TLS加密的仓库地址(https)，所有非https仓库默认无法登陆也无法拉取镜像。insecure-registries字面意思为不安全的仓库，通过添加这个参数对非https仓库进行授信。可以设置多个insecure-registries地址，以数组形式书写，地址不能添加协议头(http)。

编辑sudo  /etc/docker/daemon.json 加入以下内容:

```
{
"insecure-registries": ["192.168.1.100","IP:PORT"]
}
```


#### 配置镜像加速地址 shell
```
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io

```
#### 重新启动

```
sudo systemctl daemon-reload && systemctl restart docker

```

### 配置Docker存储驱动

OverlayFS是一个新一代的联合文件系统，类似于AUFS，但速度更快，实现更简单。Docker为OverlayFS提供了两个存储驱动程序:旧版的overlay，新版的overlay2(更稳定)。

先决条件:

* overlay2: Linux内核版本4.0或更高版本，或使用内核版本3.10.0-514+的RHEL或CentOS。
* overlay: 主机Linux内核版本3.18+
* 支持的磁盘文件系统
    * ext4(仅限RHEL 7.1)
    * xfs(RHEL7.2及更高版本)，需要启用d_type=true。 >具体详情参考 Docker Use the OverlayFS storage driver
    
编辑/etc/docker/daemon.json加入以下内容

```
{
"storage-driver": "overlay2",
"storage-opts": ["overlay2.override_kernel_check=true"]
}
```
[rpm下载地址](https://download.docker.com/linux/centos/7/x86_64/stable/Packages/)
[官方安装教程](https://docs.docker.com/install/linux/docker-ce/centos/#prerequisites)
