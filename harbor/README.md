## harbor 安装

### Hardware
|Resource|Capacity|Description|
|---|---|---|
|CPU|minimal 2 CPU|4 CPU is preferred|
|Mem|minimal 4GB|8GB is preferred|
|Disk|minimal 40GB|160GB is preferred|
### Software
|Software|Version|Description|
|---|---|---|
|Python|version 2.7 or higher|Note that you may have to install Python on Linux distributions (Gentoo, Arch) that do not come with a Python interpreter installed by default|
|Docker engine|version 1.10 or higher|For installation instructions, please refer to: https://docs.docker.com/engine/installation/|
|Docker Compose|version 1.6.0 or higher|For installation instructions, please refer to: https://docs.docker.com/compose/install/|
|Openssl|latest is preferred|Generate certificate and keys for Harbor|
### Network ports 
|Port|Protocol|Description|
|---|---|---|
|443|HTTPS|Harbor UI and API will accept requests on this port for https protocol|
|4443|HTTPS|Connections to the Docker Content Trust service for Harbor, only needed when Notary is enabled|
|80|HTTP|Harbor UI and API will accept requests on this port for http protocol|

## 离线安装

[下载地址](https://github.com/goharbor/harbor/releases)

### 解压缩

```
$ tar xvf harbor-offline-installer-<version>.tgz

```

### 配置harbor.cf



## 执行安装
```
./install.sh
```



### 修改配置

```
$  docker-compose down -v
$ vim harbor.cfg
$  docker-compose up -d
```


### 常用命令

```
docker-compose stop
docker-compose start
```
