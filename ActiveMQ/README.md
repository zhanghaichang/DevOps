# ActiveMQ 

> 一般常见的消息中间件有:RabbitMQ,ActiveMq,RocketMQ(阿里)等，都称之为MQ(Message Queue，消息队列)，这里介绍ActiveMQ。
ActiveMQ是Apache出品，最流行的，能力强劲的开源消息总线。从设计上保证了高性能的集群，客户端-服务器，点对点。完全支持JMS1.1和J2EE1.4规范的JMSProvider实现，尽管JMS规范出台已经是很久的事情了，但是JMS在当今的J2EE应用中间仍然扮演着特殊的地位。

## ActiveMq的安装

下载：进入`http://activemq.apache.org/`下载ActiveMQ

这里在linux下进行安装。

```
$ wget https://archive.apache.org/dist/activemq/5.14.4/apache-activemq-5.14.4-bin.tar.gz # 下载
$ tar -zxvf apache-activemq-5.14.4-bin.tar.gz # 解压
$ ./apache-activemq-5.14.4/bin/activemq start # 运行activemq

$ ps -ef|grep activemq # 查看activemq进程是否启动

```
activemq命令

```
$ ./activemq start # 启动
$ ./activemq stop # 停止
```

## 访问服务

访问`127.0.0.1:8161`，访问账号默认用户名密码都是admin。（该管理页面是ActiveMQ自己使用jetty服务器实现的）
