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

## 启动rabbitmq

```
systemctl start rabbitmq-server.service
```


## 安装rabbitmq可视化管理插件

```shell

rabbitmq-plugins enable rabbitmq_management

```

## 查看状态是否启动成功

```
systemctl status rabbitmq-server.service
```

远程连接rabbitmq【默认管理ui端口15672，通信端口5672】，发现问题 默认用户和密码都是guest

## 查看用户列表

```
rabbitmqctl list_users
```

## 用户管理

```
#新增用户
rabbitmqctl add_user 用户名 密码
#删除用户
rabbitmqctl delete_user 用户名
#修改密码
rabbitmqctl change_password 用户名 新密码
```
 ## 角色管理
 
 ```
 #查看用户角色
 rabbitmqctl list_users 用户名
 #设置用户角色
 rabbitmqctl set_user_tags admin 角色名称（支持同时设置多个角色）
 ```
 
## 权限管理

> 用户权限是指用户对exchange，queue的操作权限，包括配置权限，读写权限。配置权限会影响到exchange，queue的声明和删除。读写权限会影响到queue的读写消息、exchange发送消息以及queue和exchange的绑定操作。

```
rabbitmqctl list_user_permissions 用户名
rabbitmqctl set_permissions -p 虚拟主机名称 用户名
```

## 虚拟主机管理

```
#查看虚拟主机
rabbitmqctl list_vhosts
```
