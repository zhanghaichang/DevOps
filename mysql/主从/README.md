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
docker run -d -p 3606:3306 --name=mysql -v /data/mysql/conf:/etc/mysql/conf.d -v /data/mysql/mysql:/var/lib/mysql -w /var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7.29
```

