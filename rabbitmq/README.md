# RabbitMQ

> RabbitMQ是实现了高级消息队列协议（AMQP）的开源消息代理软件（亦称面向消息的中间件）。RabbitMQ服务器是用Erlang语言编写的，而集群和故障转移是构建在开放电信平台框架上的。

# Centos安装

## 安装依赖文件

```
yum -y install gcc glibc-devel make ncurses-devel openssl-devel xmlto perl wget

```
## 由于RabbitMQ需要erlang环境，所以先下载rpm源

RPM下载地址 ： `https://github.com/rabbitmq/erlang-rpm/tags?after=v22.1.4`
RabbitMq下载地址：`https://github.com/rabbitmq/rabbitmq-server/tags?after=v3.8.0-beta.7`


## 安装erlang环境

```shell
yum -y install esl-erlang_23.0.2-1_centos_7_amd64.rpm

#查看安装成功

erl -version
```

## 安装rabbitmq

```shell
yum -y install rabbitmq-server-3.8.5-1.el7.noarch.rpm
```

## 安装rabbitmq可视化管理插件

```shell

rabbitmq-plugins enable rabbitmq_management

```

## 启动rabbitmq

```
systemctl start rabbitmq-server.service
```
 
