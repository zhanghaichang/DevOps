# Mysql docker install

拉镜像
```
$ docker pull mysql:5.7
```

运行
```
$ sudo docker run --name first-mysql -p 3306:3306 -e MYSQL\_ROOT\_PASSWORD=123456 -d mysql

```
持久化运行

```
$ sudo docker run --name mysql -p 3306:3306 -v /docker/data/mysql:/var/lib/mysql -e MYSQL\_ROOT\_PASSWORD=topcheer123 -d mysql:5.7
```


## mysql run 

```
mysql -h localhost -P端口 -u root -p 123456 

```

## Mysql 远程登录及常用命令

### mysql服务的启动和停止
```
   net stop mysql

   net start mysql
```
### 登陆mysql
```
   语法如下： mysql -u用户名 -p用户密码

   键入命令mysql -uroot -p， 回车后提示你输入密码，输入12345，然后回车即可进入到mysql中了，mysql的提示符是：

mysql>
```
注意，如果是连接到另外的机器上，则需要加入一个参数-h机器IP

### 增加新用户

   格式：grant 权限 on 数据库.* to 用户名@登录主机 identified by "密码"

   如，增加一个用户user1密码为password1，让其可以在本机上登录， 并对所有数  据库有查询、插入、修改、删除的权限。首先用以root用户连入mysql，然后键入以下命令：
```
   grant select,insert,update,delete on *.* to user1@localhost Identified by "password1";
```
如果希望该用户能够在任何机器上登陆mysql，则将localhost改为"%"。

如果你不想user1有密码，可以再打一个命令将密码去掉。
```
grant select,insert,update,delete on mydb.* to user1@localhost identified by "";
```
 

###  操作数据库

   登录到mysql中，然后在mysql的提示符下运行下列命令，每个命令以分号结束。

1、 显示数据库列表。
```
show databases;
```
缺省有两个数据库：mysql和test。 mysql库存放着mysql的系统和用户权限信息，我们改密码和新增用户，实际上就是对这个库进行操作。

2、 显示库中的数据表：
```
   use mysql;

   show tables;
```
3、 显示数据表的结构：
```
    describe 表名;
```
4、 建库与删库：
```
   create database 库名;

   drop database 库名;
```
5、 建表：
```
   use 库名;

  create table 表名(字段列表);

  drop table 表名;
```
6、 清空表中记录：
```
  delete from 表名;
```
7、 显示表中的记录：
```
  select * from 表名;
```
 

### 导出和导入数据

1. 导出数据：
```
   mysqldump --opt test > mysql.test
```
即将数据库test数据库导出到mysql.test文件，后者是一个文本文件
```
如：mysqldump -u root -p123456 --databases dbname > mysql.dbname

就是把数据库dbname导出到文件mysql.dbname中。
```
2. 导入数据:
```
   mysqlimport -u root -p123456 < mysql.dbname。
```
不用解释了吧。

3. 将文本数据导入数据库:

文本数据的字段数据之间用tab键隔开。
```
   use test;

   load data local infile "文件名" into table 表名;
```
1:使用SHOW语句找出在服务器上当前存在什么数据库：
```
   mysql> SHOW DATABASES;
```
2:2、创建一个数据库MYSQLDATA
```
  mysql> CREATE DATABASE MYSQLDATA;
```
3:选择你所创建的数据库
```
  mysql> USE MYSQLDATA; (按回车键出现Database changed 时说明操作成功!)
```
4:查看现在的数据库中存在什么表
```
  mysql> SHOW TABLES;
```
5:创建一个数据库表
```
  mysql> CREATE TABLE MYTABLE (name VARCHAR(20), sex CHAR(1));
```
6:显示表的结构：
```
  mysql> DESCRIBE MYTABLE;
```
7:往表中加入记录
```
  mysql> insert into MYTABLE values ("hyq","M");
```
8:用文本方式将数据装入数据库表中(例如D:/mysql.txt)
```
  mysql> LOAD DATA LOCAL INFILE "D:/mysql.txt" INTO TABLE MYTABLE;
```
9:导入.sql文件命令(例如D:/mysql.sql)
```
  mysql>use database;

  mysql>source d:/mysql.sql;
```
10:删除表
```
  mysql>drop TABLE MYTABLE;
```
11:清空表
```
  mysql>delete from MYTABLE;
```
12:更新表中数据
```
  mysql>update MYTABLE set sex="f" where name='hyq';

  posted on 2006-01-10 16:21 happytian 阅读(6) 评论(0) 编辑 收藏 收藏至365Key
```
13：备份数据库
```
  mysqldump -u root 库名>xxx.data
```
14：例2：连接到远程主机上的MYSQL
```
假设远程主机的IP为：110.110.110.110，用户名为root,密码为abcd123。则键入以下命令：

  mysql -h110.110.110.110 -uroot -pabcd123                       // 远程登录
```
(注:u与root可以不用加空格，其它也一样)

3、退出MYSQL命令： exit (回车)
