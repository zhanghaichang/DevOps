# RocketMQ 安装

## Linux安装RocketMQ

准备RocketMQ安装包

```shell
wget https://downloads.apache.org/rocketmq/4.9.2/rocketmq-all-4.9.2-source-release.zip
```

离线状态下可以复制wget命令后面的http地址进行下载

## 安装环境

Java JDK ，RocketMQ是由java编写的框架 需要安装JDK

Maven仓库，需要下载一些RocketMQ相关的依赖

1.解压命令 

```
unzip rocketmq-all-4.9.2-source-release.zip
```
2.进入该文件夹 
```
cd rocketmq-all-4.9.2/
```
下载RocketMQ所需依赖（需要安装Maven）
```
mvn -Prelease-all -DskipTests clean install -U
```

修改运行内存

```
cd distribution/target/rocketmq-4.9.2/rocketmq-4.9.2

vi bin/runbroker.sh

vi bin/runserver.sh
```

3.启动

```
nohup sh bin/mqnamesrv &

tail -f ~/logs/rocketmqlogs/namesrv.log

nohup sh bin/mqbroker -n localhost:9876 &

tail -f ~/logs/rocketmqlogs/broker.log 

```
先启动mqnamesrv 启动成功之后会在/root产生log日志 mqnamesrv的默认端口号是9876

4. 关闭MQ

```
cd distribution/target/rocketmq-4.9.2/rocketmq-4.9.2

先关闭 mqbroker
 sh /bin/mqshutdown broker
再关 nameserv
 sh /bin/mqshutdown namesrv
```

