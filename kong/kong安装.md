# kong安装

1. 下载安装包：  https://bintray.com/kong/kong-community-edition-rpm/download_file?file_path=centos/7/kong-community-edition-1.0.2.el7.noarch.rpm 

2. 运行下面的两个命令进行安装  

```shell
$ sudo yum install epel-release
$ sudo yum install kong-community-edition-1.0.2.el7.noarch.rpm --nogpgcheck
```

3. 准备数据库

KONG 使用  PostgreSQL 9.5+ 或 Cassandra 3.x.x 作为数据存储。这里使用 PostgreSQL，需要事先准备好。创建一个名为 kong 的用户，并且创建一个名为 kong 的数据库。

```
$ sudo -s -u postgres
psql
CREATE USER kong WITH PASSWORD '123456'; 
CREATE DATABASE kong OWNER kong;
GRANT ALL PRIVILEGES ON DATABASE kong to kong;
```

4. 数据库连接配置

复制配置文件： cp /etc/kong/kong.conf.default /etc/kong/kong.conf
编辑 /etc/kong/kong.conf， 配置下面几项


5. 配置完后，运行下面的命令：

```
$ kong migrations bootstrap -c /etc/kong/kong.conf
```

6. 启动 KONG。--vv 可以打印更多的启动日志
7. 
```
kong start -c /etc/kong/kong.conf --vv
```
7. 检查 KONG 是否正确运行

```
$ curl -i http://localhost:8001/
或者
kong health
```
8. 停止 KONG

```sell 
$ kong stop
```
