# Kafka 单机安装


### 获取镜像
* zookeeper镜像：
```
docker pull zookeeper:3.4.9
```
* kafka镜像：
```
docker pull wurstmeister/kafka:2.12-2.1.0
```
* kafka-manager镜像：
```
docker pull sheepkiller/kafka-manager:latest
```
### zookeepr run 
```
docker run --name  zookeeper --restart always -p 2181:2181 -v /data/zookeeper:/data -d zookeeper:3.4.9
```

### kafka run 

```
docker run -d --name kafka --publish 9092:9092 \
-e KAFKA_BROKER_ID=0 \
--env KAFKA_ZOOKEEPER_CONNECT=172.18.161.165:2181 \
--env KAFKA_ADVERTISED_PORT=9092 \
--env KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://47.106.217.33:9092  \
--env KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
--net=host \
wurstmeister/kafka:2.12-2.1.0
```
### Test 读写验证

读写验证的方法有很多，这里我们用kafka容器自带的工具来验证，首先进入到kafka容器的交互模式

```
docker exec -it kafka /bin/bash
```

创建一个主题：

```
cd /opt/kafka_2.12-2.1.0/bin

./kafka-topics.sh --create --zookeeper 172.18.161.165:2181 --replication-factor 1 --partitions 1 --topic my-test
```

查看刚创建的主题

```
/opt/kafka_2.12-2.1.0/bin/kafka-topics.sh --list --zookeeper 172.18.161.165:2181

```

发送消息：

```
/opt/kafka_2.12-2.1.0/bin/kafka-console-producer.sh --broker-list  localhost:9092 --topic my-test

```	

读取消息：
```
/opt/kafka_2.12-2.1.0/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-test --from-beginning \
--zookeeper 172.18.161.165:2181

```
## 创建Kafka管理节点

```
docker run -itd \
--restart=always \
--name=kafka-manager \
--link zookeeper \
-p 9000:9000 \
-e ZK_HOSTS="zookeeper:2181" \
sheepkiller/kafka-manager:latest

```
# Kafka集群搭建

## 1、软件环境

* 1、linux一台或多台，大于等于2
* 2、已经搭建好的zookeeper集群

## 2、创建目录并下载安装软件

```shell
#创建目录
cd /opt/
mkdir kafka #创建项目目录
cd kafka
mkdir kafkalogs #创建kafka消息目录，主要存放kafka消息

#下载软件
wget  http://mirror.bit.edu.cn/apache/kafka/2.1.0/kafka_2.11-2.1.0.tgz

#解压软件
tar -zxvf kafka_2.11-2.1.0.tgz
```

## 3、修改配置文件

进入到config目录
```shell
cd /opt/kafka/kafka_2.11-2.1.0/config/
```
我们可以发现在目录下：

有很多文件，这里可以发现有Zookeeper文件，我们可以根据Kafka内带的zk集群来启动，但是建议使用独立的zk集群

```shell
-rw-r--r--. 1 root root  906 Feb 12 08:37 connect-console-sink.properties
-rw-r--r--. 1 root root  909 Feb 12 08:37 connect-console-source.properties
-rw-r--r--. 1 root root 2110 Feb 12 08:37 connect-distributed.properties
-rw-r--r--. 1 root root  922 Feb 12 08:38 connect-file-sink.properties
-rw-r--r--. 1 root root  920 Feb 12 08:38 connect-file-source.properties
-rw-r--r--. 1 root root 1074 Feb 12 08:37 connect-log4j.properties
-rw-r--r--. 1 root root 2055 Feb 12 08:37 connect-standalone.properties
-rw-r--r--. 1 root root 1199 Feb 12 08:37 consumer.properties
-rw-r--r--. 1 root root 4369 Feb 12 08:37 log4j.properties
-rw-r--r--. 1 root root 2228 Feb 12 08:38 producer.properties
-rw-r--r--. 1 root root 5699 Feb 15 18:10 server.properties
-rw-r--r--. 1 root root 3325 Feb 12 08:37 test-log4j.properties
-rw-r--r--. 1 root root 1032 Feb 12 08:37 tools-log4j.properties
-rw-r--r--. 1 root root 1023 Feb 12 08:37 zookeeper.properties
```
修改配置文件：server.properties：

```propertites
broker.id=0  #当前机器在集群中的唯一标识，和zookeeper的myid性质一样
port=19092 #当前kafka对外提供服务的端口默认是9092
host.name=192.168.7.100 #这个参数默认是关闭的，在0.8.1有个bug，DNS解析问题，失败率的问题。
num.network.threads=3 #这个是borker进行网络处理的线程数
num.io.threads=8 #这个是borker进行I/O处理的线程数
log.dirs=/opt/kafka/kafkalogs/ #消息存放的目录，这个目录可以配置为“，”逗号分割的表达式，上面的num.io.threads要大于这个目录的个数这个目录，如果配置多个目录，新创建的topic他把消息持久化的地方是，当前以逗号分割的目录中，那个分区数最少就放那一个
socket.send.buffer.bytes=102400 #发送缓冲区buffer大小，数据不是一下子就发送的，先回存储到缓冲区了到达一定的大小后在发送，能提高性能
socket.receive.buffer.bytes=102400 #kafka接收缓冲区大小，当数据到达一定大小后在序列化到磁盘
socket.request.max.bytes=104857600 #这个参数是向kafka请求消息或者向kafka发送消息的请请求的最大数，这个值不能超过java的堆栈大小
num.partitions=1 #默认的分区数，一个topic默认1个分区数
log.retention.hours=168 #默认消息的最大持久化时间，168小时，7天
message.max.byte=5242880  #消息保存的最大值5M
default.replication.factor=2  #kafka保存消息的副本数，如果一个副本失效了，另一个还可以继续提供服务
replica.fetch.max.bytes=5242880  #取消息的最大直接数
log.segment.bytes=1073741824 #这个参数是：因为kafka的消息是以追加的形式落地到文件，当超过这个值的时候，kafka会新起一个文件
log.retention.check.interval.ms=300000 #每隔300000毫秒去检查上面配置的log失效时间（log.retention.hours=168 ），到目录查看是否有过期的消息如果有，删除
log.cleaner.enable=false #是否启用log压缩，一般不用启用，启用的话可以提高性能
zookeeper.connect=192.168.7.100:12181,192.168.7.101:12181,192.168.7.107:1218 #设置zookeeper的连接端口
```
上面是参数的解释，实际的修改项为：

```
#broker.id=0  每台服务器的broker.id都不能相同


#hostname
host.name=192.168.7.100

#在log.retention.hours=168 下面新增下面三项
message.max.byte=5242880
default.replication.factor=2
replica.fetch.max.bytes=5242880

#设置zookeeper的连接端口
zookeeper.connect=192.168.7.100:12181,192.168.7.101:12181,192.168.7.107:12181
```
复制到其他Server上

> $ scp -r /opt/kafka hadoop-002:/opt/kafka/

## 4、启动Kafka集群并测试

1、启动服务

```shell
#从后台启动Kafka集群（3台都需要启动）
cd /opt/kafka/kafka_2.11-2.1.0/bin
#进入到kafka的bin目录 
./kafka-server-start.sh -daemon ../config/server.properties
```
2、检查服务是否启动

```
#执行命令jps
20348 Jps
4233 QuorumPeerMain
18991 Kafka
```

3、创建Topic来验证是否创建成功

```shell
#创建Topic
./kafka-topics.sh --create --zookeeper 192.168.7.100:12181 --replication-factor 2 --partitions 1 --topic shuaige
#解释
--replication-factor 2   #复制两份
--partitions 1 #创建1个分区
--topic #主题为shuaige

'''在一台服务器上创建一个发布者'''
#创建一个broker，发布者
./kafka-console-producer.sh --broker-list 192.168.7.100:19092 --topic shuaige

'''在一台服务器上创建一个订阅者'''
./kafka-console-consumer.sh --zookeeper localhost:12181 --topic shuaige --from-beginning
```
测试（在发布者那里发布消息看看订阅者那里是否能正常收到~）：

4、其他命令

大部分命令可以去官方文档查看

4.1、查看topic

```shell
./kafka-topics.sh --list --zookeeper localhost:12181
#就会显示我们创建的所有topic
```
4.2、查看topic状态

```shell
/kafka-topics.sh --describe --zookeeper localhost:12181 --topic shuaige
#下面是显示信息
Topic:ssports    PartitionCount:1    ReplicationFactor:2    Configs:
    Topic: shuaige    Partition: 0    Leader: 1    Replicas: 0,1    Isr: 1
#分区为为1  复制因子为2   他的  shuaige的分区为0 
#Replicas: 0,1   复制的为0，1
#
```
OK  kafka集群搭建完毕


5、其他说明标注

5.1、日志说明

默认kafka的日志是保存在/opt/kafka/kafka_2.11-2.1.0/logs目录下的，这里说几个需要注意的日志

```shell
server.log #kafka的运行日志
state-change.log  #kafka他是用zookeeper来保存状态，所以他可能会进行切换，切换的日志就保存在这里

controller.log #kafka选择一个节点作为“controller”,当发现有节点down掉的时候它负责在游泳分区的所有节点中选择新的leader,这使得Kafka可以批量的高效的管理所有分区节点的主从关系。如果controller down掉了，活着的节点中的一个会备切换为新的controller.
```

5.2、上面的大家你完成之后可以登录zk来查看zk的目录情况

```shell
#使用客户端进入zk
./zkCli.sh -server 127.0.0.1:12181  #默认是不用加’-server‘参数的因为我们修改了他的端口

#查看目录情况 执行“ls /”
[zk: 127.0.0.1:12181(CONNECTED) 0] ls /

#显示结果：[consumers, config, controller, isr_change_notification, admin, brokers, zookeeper, controller_epoch]
```

上面的显示结果中：只有zookeeper是，zookeeper原生的，其他都是Kafka创建的

```shell
#标注一个重要的
[zk: 127.0.0.1:12181(CONNECTED) 1] get /brokers/ids/0
{"jmx_port":-1,"timestamp":"1456125963355","endpoints":["PLAINTEXT://192.168.7.100:19092"],"host":"192.168.7.100","version":2,"port":19092}
cZxid = 0x1000001c1
ctime = Mon Feb 22 15:26:03 CST 2016
mZxid = 0x1000001c1
mtime = Mon Feb 22 15:26:03 CST 2016
pZxid = 0x1000001c1
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x152e40aead20016
dataLength = 139
numChildren = 0
[zk: 127.0.0.1:12181(CONNECTED) 2] 

#还有一个是查看partion
[zk: 127.0.0.1:12181(CONNECTED) 7] get /brokers/topics/shuaige/partitions/0
null
cZxid = 0x100000029
ctime = Mon Feb 22 10:05:11 CST 2016
mZxid = 0x100000029
mtime = Mon Feb 22 10:05:11 CST 2016
pZxid = 0x10000002a
cversion = 1
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 0
numChildren = 1
[zk: 127.0.0.1:12181(CONNECTED) 8]
```
