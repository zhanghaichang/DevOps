# walle 
> 让用户代码发布终于可以不只能选择 jenkins！支持各种web代码发布，php、java、python、go等代码的发布、回滚可以通过web来一键完成。walle 一个可自由配置项目，更人性化，高颜值，支持git、多用户、多语言、多项目、多环境同时部署的开源上线部署系统。

## Install Docker 
```
sudo yum install -y yum-utils  device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo  https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl enable docker
sudo systemctl start docker
```
在安装过程中，也许会遇到Requires: container-selinux >= 2.9 的异常；
可以打开Centos下载包中的最新container-selinux包的地址,
然后运行：

```
sudo yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.68-1.el7.noarch.rpm
```

## Install docker-compose

```
sudo yum install python-pip 
sudo pip install --upgrade pip

pip install docker-compose -i https://mirrors.aliyun.com/pypi/simple/

```

## NEW environment file

在docker-compose.yml同级目录新建walle.env，连接数据库MYSQL_USER默认使用root,如需使用其他用户，需自建用户更改walle.env文件

vi walle.env

```
# Set MySQL/Rails environment
MYSQL_USER=root
MYSQL_PASSWORD=walle
MYSQL_DATABASE=walle
MYSQL_ROOT_PASSWORD=walle
MYSQL_HOST=db
MYSQL_PORT=3306
```

### 准备部署
vim docker-compose.yml
```
# docker version:  18.06.0+
# docker-compose version: 1.23.2+
# OpenSSL version: OpenSSL 1.1.0h
version: "3.7"
services:
  web:
    image: alenx/walle-web:2.1
    container_name: walle-nginx
    hostname: nginx-web
    ports:
      # 如果宿主机80端口被占用，可自行修改为其他port(>=1024)
      # 0.0.0.0:要绑定的宿主机端口:docker容器内端口80
      - "80:80"
    depends_on:
      - python
    networks:
      - walle-net
    restart: always

  python:
    image: alenx/walle-python:2.1
    container_name: walle-python
    hostname: walle-python
    env_file:
      # walle.env需和docker-compose在同级目录
      - ./walle.env
    command: bash -c "cd /opt/walle_home/ && /bin/bash admin.sh migration &&  python waller.py"
    expose:
      - "5000"
    volumes:
      - /opt/walle_home/plugins/:/opt/walle_home/plugins/
      - /opt/walle_home/codebase/:/opt/walle_home/codebase/
      - /opt/walle_home/logs/:/opt/walle_home/logs/
      - /root/.ssh:/root/.ssh/
    depends_on:
      - db
    networks:
      - walle-net
    restart: always

  db:
    image: mysql
    container_name: walle-mysql
    hostname: walle-mysql
    env_file:
      - ./walle.env
    command: [ '--default-authentication-plugin=mysql_native_password', '--character-set-server=utf8mb4', '--collation-server=utf8mb4_unicode_ci']
    ports:
      - "3306:3306"
    expose:
      - "3306"
    volumes:
      - /data/walle/mysql:/var/lib/mysql
    networks:
      - walle-net
    restart: always

networks:
  walle-net:
    driver: bridge
```
### 启动

一键启动（快速体验）

```
docker-compose up -d && docker-compose logs -f
# 打开浏览器localhost:80

```

初始登录账号如下，开启你的walle 2.0之旅吧：）

```
超管：super@walle-web.io \ Walle123
所有者：owner@walle-web.io \ Walle123
负责人：master@walle-web.io \ Walle123
开发者：developer@walle-web.io \ Walle123
访客：reporter@walle-web.io \ Walle123
```

### 常用操作

```
# 构建服务
docker-compose build
# 启动服务,启动过程中可以直接查看终端日志，观察启动是否成功
docker-compose up
# 启动服务在后台，如果确认部署成功，则可以使用此命令，将应用跑在后台，作用类似 nohup python waller.py &
docker-compose up -d
# 查看日志,效果类似 tail -f waller.log
docker-compose logs -f
# 停止服务,会停止服务的运行，但是不会删除服务所所依附的网络，以及存储等
docker-compose stop
# 删除服务，并删除服务产生的网络，存储等，并且会关闭服务的守护
docker-compose down
```

### Error

如果遇见一下错误，请docker-compose down之后再docker-compose up一次就可以了，这是mysql没有初始化完，就启动了python-server
