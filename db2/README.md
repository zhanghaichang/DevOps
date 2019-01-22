# Db2 安装

[dbeaver](https://dbeaver.io/download/)

db2_developer_c

```
docker pull store/ibmcorp/db2_developer_c:11.1.4.4-x86_64
```


```
docker run -h db2server_developer_c --name db2server --restart=always  --detach --privileged=true -p 50000:50000 -p 55000:55000  --env-file /data/db2/.env_list  -v /data/db2/data/:/database store/ibmcorp/db2_developer_c:11.1.4.4-x86_64
```


```
docker exec -ti d4fc021e52aa bash -c "su - ${DB2INSTANCE}"
```



## db2创建数据库和导入导出数据库

### 1、切换用户

```shell
su - db2inst1

```
### 2、创建数据库

```shell
db2 create db databaseName using codeset utf-8 territory CN
```

注意：

`1.出现错误：SQL1004C there` `is` `not` `enough storage` `on` `the file` `to` `process the command``----物理空间不足`

`2.创建数据库失败（中间断掉或空间不足引起）无法重新创建，提示已存在，SQL1005N，此时需要删除掉重新创建 <br><strong>解决方案</strong>：`

`查看是否存在系统数据库目录中`

```
db2 list db directory
```

`若存在则可以直接删除`
```
`db2` `drop` `db databasename`
```
`注意系统创建的文件不能随意删除再复制回来需要修改权限否者出现SQL1036C  An I/O error occurred while accessing the` `database``.  SQLSTATE=58030`

`若不存在则需要添加进来再删除`
```
`db2 catalog db databasename`
```
`将数据库移除系统数据库目录中`
```
`db2 uncatalog db databasename`
```
### 3、连接新数据库
```
db2 connect to databaseName
```
### 4、创建BUFFERPOOL
```
db2 create BUFFERPOOL testBUFFER SIZE 1000 PAGESIZE 32K
```
### 5、创建TABLESPACE
```
db2 create TABLESPACE testSpace PAGESIZE 32K MANAGED BY SYSTEM USING ('/home/db2inst1/test/ts') BUFFERPOOL testBUFFER
```
### 6、创建临时表空间
```
db2 create SYSTEM TEMPORARY TABLESPACE testBUF PAGESIZE 32 K MANAGED BY SYSTEM USING ('/home/db2inst1/epay/tts') BUFFERPOOL testBUFFER
```
### 7、断开连接
```
db2 disconnect databaseName
```
### 8、使用db2inst1角色连接数据库
```
db2 connect to databaseName
```
### 9、创建用户和密码用于连接数据库（一个库下使用不同用户连接数据库管理各自的表（但是数据库名字是同一个，只需连接是指定用户名密码）类似oracle）

```
`useradd username`

`passwd` `password`
```

### 10、db2inst1进行授权

使用db2inst1连接数据库进行授权给指定用户后，该用户才可以有权访问表

```
db2 grant dbadm on database to user userName
```
### 11、使用创建用户重新连接数据库进行添加当前用户下的表

```
`db2` `connect` `to` `databaseName` `user` `username using` `password`
```

### 12、导出数据库的所有表及数据（导出的文件是db2move.lst、export.out、tabxx.ixf、tabxx.msg）
```
`db2move <数据库名> export`
```
### 13、导入数据库的所有表及数据（需要修改db2move.lst中的第一个字段是用户名，管理需要导入的表，不需要导入的直接删除即可也可以修改用户）
```
`db2move <数据库名> import`
```
### 14、导出表创建语句
```
`db2look -d <数据库名> -u <用户> -e -o <脚本名称>.sql`
```
### 15、运行sql脚本
```
`db2 -tvf  <脚本名称>.sql`
```
### 16、导出单个表数据（只能导出一个表）
```
`db2 export` `to` `test.txt` `of` `del` `select` `*` `from` `test`
```
17、导入单个表数据

```
`db2 import` `from` `test.txt` `of` `del` `insert` `into` `test`
```
总结：

针对数据库操作千万不要手动删除数据库文件

db2可以创建多个库，也可以只创建一个数据库使用不用的用户进行登录，管理各自的表

