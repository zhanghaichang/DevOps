# Zookeeper 的集群安装及配置

  

### 下载

[下载地址](http://zookeeper.apache.org/) 我们下载了最新的`zookeeper-3.4.11`。

### 安装

**1、解压**

```shell
$ tar zxvf zookeeper-3.4.11.tar.gz
```

**2、移动到/usr/local目录下**

```shell
$ mv zookeeper-3.4.11 /usr/local/zookeeper
```

### 集群配置

Zookeeper集群原则上需要2n+1个实例才能保证集群有效性，所以集群规模至少是3台。

下面演示如何创建3台的Zookeeper集群，N台也是如此。

**1、创建数据文件存储目录**

```shell
$ cd /usr/local/zookeeper$ mkdir data
```
**2、添加主配置文件**

```shell
$ cd conf$ cp zoo_sample.cfg zoo.cfg
```
**3、修改配置**
```shell
$ vi zoo.cfg
```
先把`dataDir=/tmp/zookeeper`注释掉，然后添加以下核心配置。
```shell
dataDir=/usr/local/zookeeper/dataserver.1=192.168.10.31:2888:3888server.2=192.168.10.32:2888:3888server.3=192.168.10.33:2888:3888
```
**4、创建myid文件**
```shell
 $ cd ../data$ touch myid$ echo "1">>myid
```
每台机器的myid里面的值对应server.后面的数字x。

**5、开放3个端口**
```shell
$ sudo /sbin/iptables -I INPUT -p tcp --dport 2181 -j ACCEPT$ sudo /sbin/iptables -I INPUT -p tcp --dport 2888 -j ACCEPT$ sudo /sbin/iptables -I INPUT -p tcp --dport 3888 -j ACCEPT$ sudo /etc/rc.d/init.d/iptables save$ sudo /etc/init.d/iptables restart$ sudo /sbin/iptables -L -nChain INPUT (policy ACCEPT)target     prot opt source               destination         ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:3888 ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:2888 ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:2181
```
**6、配置集群其他机器**

把配置好的Zookeeper目录复制到其他两台机器上，重复上面4-5步。
```shell
$ scp -r /usr/local/zookeeper test@192.168.10.32:/usr/local/
```
**7、重启集群**
```shell
$ /usr/local/zookeeper/bin/zkServer.sh start
```
3个Zookeeper都要启动。

**8、查看集群状态**
```shell
$ /usr/local/zookeeper/bin/zkServer.sh status ZooKeeper JMX enabled by defaultUsing config: /usr/local/zookeeper/bin/../conf/zoo.cfgMode: follower
```
### 客户端连接
```shell
./zkCli.sh -server 192.168.10.31:2181
```
连接本机的不用带-server。

### 注意

如果是在单机创建的多个Zookeeper伪集群，需要对应修改配置中的端口、日志文件、数据文件位置等配置信息。
