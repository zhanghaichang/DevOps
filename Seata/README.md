# Seata-server 安装、运行


### 一、下载并安装

```
wget -P /opt/downloads https://github.com/seata/seata/releases/download/v0.9.0/seata-server-0.9.0.tar.gz
mkdir /opt/seata-server
tar zxvf /opt/downloads/seata-server-0.9.0.tar.gz -C /opt/seata-server
mv /opt/seata-server/seata/* /opt/seata-server
rm -r /opt/seata-server/seata/

```

### 二、导入配置

本文使用nacos作为配置中心和服务发现，file、apollo、redis、zk、consul等也可以举一反三。

我们这里用默认的导入先让seata-server跑起来，过后对着file.conf和java程序启动后的报错调整，重新导入即可。


```
vim /opt/seata-server/conf/nacos-config.txt

```

以下是我根据自己的环境修改后的配置值

```
transport.type=TCPtransport.server=NIOtransport.heartbeat=truetransport.thread-factory.boss-thread-prefix=NettyBosstransport.thread-factory.worker-thread-prefix=NettyServerNIOWorkertransport.thread-factory.server-executor-thread-prefix=NettyServerBizHandlertransport.thread-factory.share-boss-worker=falsetransport.thread-factory.client-selector-thread-prefix=NettyClientSelectortransport.thread-factory.client-selector-thread-size=1transport.thread-factory.client-worker-thread-prefix=NettyClientWorkerThreadtransport.thread-factory.boss-thread-size=1transport.thread-factory.worker-thread-size=8transport.shutdown.wait=3service.vgroup_mapping.my_test_tx_group=defaultservice.vgroup_mapping.user-web-seata-service-group=defaultservice.vgroup_mapping.user-seata-service-group=defaultservice.vgroup_mapping.order-seata-service-group=defaultservice.vgroup_mapping.user2-seata-service-group=defaultservice.vgroup_mapping.order2-seata-service-group=defaultservice.vgroup_mapping.business-service-seata-service-group=defaultservice.vgroup_mapping.account-service-seata-service-group=defaultservice.vgroup_mapping.storage-service-seata-service-group=defaultservice.vgroup_mapping.order-service-seata-service-group=defaultservice.default.grouplist=192.168.0.101:8091service.enableDegrade=falseservice.disable=falseservice.max.commit.retry.timeout=-1service.max.rollback.retry.timeout=-1client.async.commit.buffer.limit=10000client.lock.retry.internal=10client.lock.retry.times=30client.lock.retry.policy.branch-rollback-on-conflict=trueclient.table.meta.check.enable=trueclient.report.retry.count=5client.tm.commit.retry.count=1client.tm.rollback.retry.count=1store.mode=dbstore.file.dir=file_store/datastore.file.max-branch-session-size=16384store.file.max-global-session-size=512store.file.file-write-buffer-cache-size=16384store.file.flush-disk-mode=asyncstore.file.session.reload.read_size=100store.db.datasource=druidstore.db.db-type=mysqlstore.db.driver-class-name=com.mysql.jdbc.Driverstore.db.url=jdbc:mysql://192.168.0.101:3306/seata?useUnicode=truestore.db.user=rootstore.db.password=rootstore.db.min-conn=1store.db.max-conn=3store.db.global.table=global_tablestore.db.branch.table=branch_tablestore.db.query-limit=100store.db.lock-table=lock_tablerecovery.committing-retry-period=1000recovery.asyn-committing-retry-period=1000recovery.rollbacking-retry-period=1000recovery.timeout-retry-period=1000transaction.undo.data.validation=truetransaction.undo.log.serialization=jacksontransaction.undo.log.save.days=7transaction.undo.log.delete.period=86400000transaction.undo.log.table=undo_logtransport.serialization=seatatransport.compressor=nonemetrics.enabled=falsemetrics.registry-type=compactmetrics.exporter-list=prometheusmetrics.exporter-prometheus-port=9898support.spring.datasource.autoproxy=false
```

ha见https://github.com/seata/seata-samples/tree/master/ha

service.default.grouplist为seata集群地址集

建立集群数据库 

https://github.com/seata/seata/blob/v0.9.0/server/src/main/resources/db_store.sql

注意版本对应分支，官方链接指向了develop分支sql不同是会报错的

```sql
-- the table to store GlobalSession data
drop table if exists `global_table`;
create table `global_table` (
  `xid` varchar(128)  not null,
  `transaction_id` bigint,
  `status` tinyint not null,
  `application_id` varchar(32),
  `transaction_service_group` varchar(32),
  `transaction_name` varchar(128),
  `timeout` int,
  `begin_time` bigint,
  `application_data` varchar(2000),
  `gmt_create` datetime,
  `gmt_modified` datetime,
  primary key (`xid`),
  key `idx_gmt_modified_status` (`gmt_modified`, `status`),
  key `idx_transaction_id` (`transaction_id`)
);

-- the table to store BranchSession data
drop table if exists `branch_table`;
create table `branch_table` (
  `branch_id` bigint not null,
  `xid` varchar(128) not null,
  `transaction_id` bigint ,
  `resource_group_id` varchar(32),
  `resource_id` varchar(256) ,
  `lock_key` varchar(128) ,
  `branch_type` varchar(8) ,
  `status` tinyint,
  `client_id` varchar(64),
  `application_data` varchar(2000),
  `gmt_create` datetime,
  `gmt_modified` datetime,
  primary key (`branch_id`),
  key `idx_xid` (`xid`)
);

-- the table to store lock data
drop table if exists `lock_table`;
create table `lock_table` (
  `row_key` varchar(128) not null,
  `xid` varchar(96),
  `transaction_id` long ,
  `branch_id` long,
  `resource_id` varchar(256) ,
  `table_name` varchar(32) ,
  `pk` varchar(36) ,
  `gmt_create` datetime ,
  `gmt_modified` datetime,
  primary key(`row_key`)
);
```


store.db.datasource的选择 ## the implement of javax.sql.DataSource, such as DruidDataSource(druid)/BasicDataSource(dbcp) etc.

store.db.driver-class-name = "com.mysql.jdbc.Driver"   store.db.driver-class-name = "com.mysql.cj.jdbc.Driver"

选择druid和com.mysql.jdbc.Driver(目前seata驱动为5.1.30)

 

导入配置到nacos。

格式为sh nacos-config.sh $Nacos-Server-IP

因为nacos-config.sh脚本中已经把8848端口写死，如果你的nacos-server不是8848端口，请修改nacos-config.sh。

```
cd /opt/seata-server/conf/
bash /opt/seata-server/conf/nacos-config.sh nacosserver
```

nacosserver是nacos的ip
脚本执行最后输出 "init nacos config finished, please start seata-server." 说明推送配置成功。若想进一步确认可登陆Nacos控制台->配置列表->筛选查询Group为SEATA_GROUP的配置项。

将/opt/seata-server/conf/nacos-config.txt 脚本修改后重新导入即可。

 ### 三、启动seata-server(事务协调器)
 
 修改日志目录(非必须)
 
`vim /opt/seata-server/conf/logback.xml`

改为

```xml
    <!--<property name="LOG_HOME" value="${user.home}/logs/seata"/>-->
    <property name="LOG_HOME" value="/var/log/seata-server"/>
```
> sudo mkdir -p /var/log/seata-server;sudo chmod -R 777 /var/log/seata-server
 
 配置修改

vim /opt/seata-server/conf/registry.conf 并复制到java代码的properties目录下

```
registry {
  # file 、nacos 、eureka、redis、zk、consul、etcd3、sofa
  type = "nacos"

  nacos {
    serverAddr = "nacosserver"
    namespace = "public"
    cluster = "default"
  }
  eureka {
    serviceUrl = "http://localhost:8761/eureka"
    application = "default"
    weight = "1"
  }
  redis {
    serverAddr = "localhost:6379"
    db = "0"
  }
  zk {
    cluster = "default"
    serverAddr = "127.0.0.1:2181"
    session.timeout = 6000
    connect.timeout = 2000
  }
  consul {
    cluster = "default"
    serverAddr = "127.0.0.1:8500"
  }
  etcd3 {
    cluster = "default"
    serverAddr = "http://localhost:2379"
  }
  sofa {
    serverAddr = "127.0.0.1:9603"
    application = "default"
    region = "DEFAULT_ZONE"
    datacenter = "DefaultDataCenter"
    cluster = "default"
    group = "SEATA_GROUP"
    addressWaitTime = "3000"
  }
  file {
    name = "file.conf"
  }

}


config {
  # file、nacos 、apollo、zk、consul、etcd3
  type = "nacos"

  nacos {
    serverAddr = "nacosserver"
    namespace = ""
  }
  consul {
    serverAddr = "127.0.0.1:8500"
  }
  apollo {
    app.id = "seata-server"
    apollo.meta = "http://192.168.1.204:8801"
  }
  zk {
    serverAddr = "127.0.0.1:2181"
    session.timeout = 6000
    connect.timeout = 2000
  }
  etcd3 {
    serverAddr = "http://localhost:2379"
  }
  file {
    name = "file.conf"
  }
}
```

注：serverAddr不要填端口号   public为小写

有处BUG：config.nacos.namespace="public"的值要去掉public写成""

 

启动格式sh seata-server.sh $LISTEN_PORT $PATH_FOR_PERSISTENT_DATA $IP(此参数可选)

$IP参数 用于多IP环境下指定 Seata-Server 注册服务的IP    虽然是可选，但还是要填，之前我偷懒没填，一大堆虚拟ip各种乱定位。

命令启动

`sh /opt/seata-server/bin/seata-server.sh -p 8091 -h 192.168.0.101 -m db -n 1`

守护进程启动

`vim /opt/seata-server/startup.sh`

`vim /lib/systemd/system/seata-server.service`
文件中填入

```shell
[Unit]
Description=seata-serverAfter=syslog.target network.target remote-fs.target nss-lookup.target[Service]Type=simpleExecStart=/opt/seata-server/startup.shRestart=alwaysPrivateTmp=true[Install]WantedBy=multi-user.target
```

赋予权限

```
chmod 777 /opt/seata-server/startup.sh
chmod 777 /lib/systemd/system/seata-server.service

```

启用服务
```
systemctl enable seata-server.service
systemctl daemon-reload
```

运行
`systemctl start seata-server.service`
查看状态
`systemctl status seata-server.service`
查看进程
`ps -ef|grep seata-server`

运行成功后可在Nacos控制台的 服务列表 看到 服务名serverAddr的条目

查看日志
```
sudo journalctl -u seata-server
sudo journalctl -u seata-server --since="2019-11-11 11:11:11"
sudo journalctl -u seata-server --since "30 min ago"
sudo journalctl -u seata-server --since yesterday
sudo journalctl -u seata-server --since "2019-11-10" --until "2018-11-11 11:11"
sudo journalctl -u seata-server --since 04:00 --until "2 hour ago"
```

### 四、创建数据表

(创建mysql数据库略)
UNDO_LOG table is required by SEATA AT mode.
```
-- for AT mode you must to init this sql for you business databese. the seata server not need it.
drop table `undo_log`;
CREATE TABLE `undo_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'increment id',
  `branch_id` bigint(20) NOT NULL COMMENT 'branch transaction id',
  `xid` varchar(100) NOT NULL COMMENT 'global transaction id',
  `context` varchar(128) NOT NULL COMMENT 'undo_log context,such as serialization',
  `rollback_info` longblob NOT NULL COMMENT 'rollback info',
  `log_status` int(11) NOT NULL COMMENT '0:normal status,1:defense status',
  `log_created` datetime NOT NULL COMMENT 'create datetime',
  `log_modified` datetime NOT NULL COMMENT 'modify datetime',
  `ext` varchar(100) DEFAULT NULL COMMENT 'reserved field',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_undo_log` (`xid`,`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='AT transaction mode undo table';
```

每个业务数据库都要建一个undo_log表
