# MySQL5.7主从同步配置

> 主从同步，将主服务器（master）上的数据复制到从服务器（slave）。

### 应用场景
* 读写分离，提高查询访问性能，有效减少主数据库访问压力。
* 实时灾备，主数据库出现故障时，可快速切换到从数据库。
* 数据汇总，可将多个主数据库同步汇总到一个从数据库中，方便数据统计分析。

### 部署环境
> 注：使用docker部署mysql实例，方便快速搭建演示环境。但本文重点是讲解主从配置，因此简略描述docker环境构建mysql容器实例。

* 数据库：MySQL 5.7.29 （相比5.5，5.6而言，5.7同步性能更好，支持多源复制，可实现多主一从，主从库版本应保证一致）
* 操作系统：CentOS 7.x
* 容器：Docker 17.09.0-ce
* 镜像：mysql:5.7.29

### 配置约束
* 主从库必须保证网络畅通可访问
* 主库必须开启binlog日志
* 主从库的server-id必须不同

### 事前准备

* 安装Docker
* 创建持久化目录

```
mkdir -p /data/mysql-100/{mysql,conf,data}
mkdir -p /data/mysql-110/{mysql,conf,data}
```

### 【主库】操作及配置

配置my.cnf
把该文件放到主库所在配置文件路径下：/data/mysql/conf

```shell
```

### 安装启动主库

```
docker run -d -p 3306:3306 --name=mysql -v /data/mysql/conf:/etc/mysql/conf.d -v /data/mysql/mysql:/var/lib/mysql -w /var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7.29
```

### 创建授权用户

连接mysql主数据库，键入命令mysql -u root -p，输入密码后登录数据库。创建用户用于从库同步复制，授予复制、同步访问的权限

```
mysql> CREATE USER 'slave'@'%' IDENTIFIED BY '123456';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'slave'@'%';
Query OK, 0 rows affected (0.00 sec)
```
log_bin是否开启

```
mysql> show variables like 'log_bin';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | ON    |
+---------------+-------+
1 row in set
```
查看master状态

```
mysql> show master status;
+------------------+----------+--------------+--------------------------------------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB                                 | Executed_Gtid_Set |
+------------------+----------+--------------+--------------------------------------------------+-------------------+
| mysql-bin.000001 |     154  | test         | mysql,information_schema,performation_schema,sys |                   |
+------------------+----------+--------------+--------------------------------------------------+-------------------+
1 row in set
```
注意：mysql-bin.000001 跟154这俩参数从库会使用到，根据实际情况修改

### 【从库】配置及操作

配置my.cnf,把该文件放到主库所在配置文件路径下：/data/mysql/conf/

### 安装启动从库

```
docker run -d -p 3306:3306 --name=mysql-slave -v /data/mysql/conf:/etc/mysql/conf.d -v /data/mysql/mysql:/var/lib/mysql -w /var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7.29

```

### 设置主库信息
登录【从数据库】，进入mysql命令行。

```
mysql> stop slave;
Query OK, 0 rows affected

mysql> CHANGE MASTER TO MASTER_HOST='192.168.10.212',
MASTER_PORT=3506,
MASTER_USER='slave',
MASTER_PASSWORD='123456',
MASTER_LOG_FILE='mysql-bin.000001', # 主库信息
MASTER_LOG_POS=154;   # 主库信息
Query OK, 0 rows affected

mysql> start slave;
Query OK, 0 rows affected
```

stop slave; //停止同步  
start slave; //开始同步  
//必须和【主数据库】的信息匹配。  
CHANGE MASTER TO  
MASTER_HOST='192.168.10.212', //主库IP  
MASTER_PORT=3506, //主库端口   
MASTER_USER='slave', //访问主库且有同步复制权限的用户  
MASTER_PASSWORD='123456', //登录密码   
//【关键处】从主库的该log_bin文件开始读取同步信息，主库show master status返回结果   
MASTER_LOG_FILE='mysql-bin.000001',  
//【关键处】从文件中指定位置开始读取，主库show master status返回结果  
MASTER_LOG_POS=154;  


### 查看同步状态

```
# 注意\G就已经表示结束，不用再加分号(;)了，如果加上分号的话执行后在执行结果最后会有一个错误提示：
ERROR: 
No query specified

mysql> show slave status \G

*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 192.168.10.212
                  Master_User: slave
                  Master_Port: 3506
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000003
          Read_Master_Log_Pos: 2756
               Relay_Log_File: f947643ca441-relay-bin.000002
                Relay_Log_Pos: 320
        Relay_Master_Log_File: mysql-bin.000003
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: test
          Replicate_Ignore_DB: mysql,information_schema,performation_schema,sys
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 2756
              Relay_Log_Space: 534
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 100
                  Master_UUID: 1c0ec77d-dcee-11e8-bd51-0242ac11000a
             Master_Info_File: /datavol/mysql/data/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
1 row in set (0.00 sec)
```

*只有【Slave_IO_Running】和【Slave_SQL_Running】都是Yes，则同步是正常的。*

如果是No或者Connecting都不行，可查看mysql-error.log，以排查问题。

```
mysql> show variables like 'log_error%';
+---------------------+--------+
| Variable_name       | Value  |
+---------------------+--------+
| log_error           | stderr |
| log_error_verbosity | 3      |
+---------------------+--------+
2 rows in set
```

配置完成，则主从数据库开始自动同步。

#### 验证数据同步

建库



#### 补充：

* 如果【主服务器】重启mysql服务，【从服务器】会等待与【主服务器】重连。当主服务器恢复正常后，从服务器会自动重新连接上主服务器，并正常同步数据。
* 如果某段时间内，【从数据库】服务器异常导致同步中断（可能是同步点位置不匹配），可以尝试以下恢复方法：进入【主数据库】服务器（正常），在bin-log中找到【从数据库】出错前的position，然后在【从数据库】上执行change master，将master_log_file和master_log_pos重新指定后，开始同步。
使用root账号登录【主服务器】，创建test数据库


###  问题处理

删除失败，在master上删除一条记录，而slave上找不到。

```
Last_SQL_Error: Could not execute Delete_rows event on table hcy.t1; 
Can't find record in 't1',
Error_code: 1032; handler error HA_ERR_KEY_NOT_FOUND; 
the event's master log mysql-bin.000006, end_log_pos 254
```
*解决方法：*

由于master要删除一条记录，而slave上找不到故报错，这种情况主上都将其删除了，那么从机可以直接跳过。可用命令：
```
stop slave;
set global sql_slave_skip_counter=1;
start slave;
```
