# Docker配置

对于通过systemd来管理服务的系统(比如CentOS7.X、Ubuntu16.X), Docker有两处可以配置参数: 一个是docker.service服务配置文件,一个是Docker daemon配置文件daemon.json。

docker.service

对于CentOS系统，docker.service默认位于/usr/lib/systemd/system/docker.service；对于Ubuntu系统，docker.service默认位于/lib/systemd/system/docker.service

daemon.json

daemon.json默认位于/etc/docker/daemon.json，如果没有可手动创建，基于systemd管理的系统都是相同的路径。通过修改daemon.json来改过Docker配置，也是Docker官方推荐的方法。

> 以下说明均基于systemd,并通过/etc/docker/daemon.json来修改配置。

## 配置镜像下载和上传并发数

从Docker1.12开始，支持自定义下载和上传镜像的并发数，默认值上传为3个并发，下载为5个并发。通过添加”max-concurrent-downloads”和”max-concurrent-uploads”参数对其修改:

```shell
"max-concurrent-downloads": 3,
"max-concurrent-uploads": 5
```

## 配置镜像加速地址

Rancher从v1.6.15开始到v2.x.x,Rancher系统相关的所有镜像(包括1.6.x上的K8S镜像)都托管在Dockerhub仓库。Dockerhub节点在国外，国内直接拉取镜像会有些缓慢。为了加速镜像的下载，可以给Docker配置国内的镜像地址。

编辑`/etc/docker/daemon.json`加入以下内容

```shell
{
"registry-mirrors": ["https://7bezldxe.mirror.aliyuncs.com/","https://IP:PORT/"]
}
```
> 可以设置多个registry-mirrors地址，以数组形式书写，地址需要添加协议头(https或者http)。

## 配置insecure-registries私有仓库

Docker默认只信任TLS加密的仓库地址(https)，所有非https仓库默认无法登陆也无法拉取镜像。insecure-registries字面意思为不安全的仓库，通过添加这个参数对非https仓库进行授信。可以设置多个insecure-registries地址，以数组形式书写，地址不能添加协议头(http)。

编辑/etc/docker/daemon.json加入以下内容:

```shell
{
"insecure-registries": ["192.168.1.100","IP:PORT"]
}
```

## 配置Docker存储驱动

OverlayFS是一个新一代的联合文件系统，类似于AUFS，但速度更快，实现更简单。Docker为OverlayFS提供了两个存储驱动程序:旧版的overlay，新版的overlay2(更稳定)。

先决条件:
overlay2: Linux内核版本4.0或更高版本，或使用内核版本3.10.0-514+的RHEL或CentOS。
overlay: 主机Linux内核版本3.18+
支持的磁盘文件系统
ext4(仅限RHEL 7.1)
xfs(RHEL7.2及更高版本)，需要启用d_type=true。 >具体详情参考 Docker Use the OverlayFS storage driver

编辑/etc/docker/daemon.json加入以下内容
```
{
"storage-driver": "overlay2",
"storage-opts": ["overlay2.override_kernel_check=true"]
}
```

## 配置日志驱动

容器在运行时会产生大量日志文件，很容易占满磁盘空间。通过配置日志驱动来限制文件大小与文件的数量。 >限制单个日志文件为100M,最多产生3个日志文件

```
{
"log-driver": "json-file",
"log-opts": {
    "max-size": "100m",
    "max-file": "3"
    }
}
```

