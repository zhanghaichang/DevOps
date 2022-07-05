# FLASHBACK ARCHIVE

## 背景：

Oracle 11g 中 Flashback Data Archive 特性。将变化数据另外存储到创建的闪回归档区（Flashback Archive）中，以和 undo 区别开来，这样就可以为闪回归档区单独设置存储策略，使之可以闪回到指定时间之前的旧数据而不影响 undo 策略。并且可以根据需要指定哪些数据库对象需要保存历史变化数据，而不是将数据库中所有对象的变化数据都保存下来，而只是记录了指定表的数据变化。所以，Flashback Data Archive 是针对对象的保护，是 Flashback Database 的有力补充。

## 闪回数据归档区：

闪回数据归档区是闪回数据归档的历史数据存储区域，每一个闪回数据归档区都可以有一个唯一的名称，对应了一定的数据保留策略。
在一个系统中，可以有一个默认的闪回数据归档区，也可以创建其他许多的闪回数据归档区域。

Flashback archive 的限制条件：
1）Flashback data archive 只能在 ASSM 的 tablespace 上创建
2）Flashback data archive 要求必须使用自动 undo 管理，即 undo_management 参数为 auto

Flashback archive 的后台进程：
Oracle11g 为 Flashback data archive 特性专门引入了一个新的后台进程FBDA，用于将追踪表(traced table，也就是将指定使用 flashback data archive 的table)的历史变化数据转存到闪回归档区。
-- 查看 FDBA 进程
SQL> select name,description from v$bgprocess where name='FBDA';
NAME DESCRIPTION

FBDA Flashback Data Archiver Process

## FDA 管理操作：

```sql
--创建一个默认的 Flashback Archive, 配额为 10M，数据保留期为 7 天
SQL> create flashback archive default fda01 tablespace fda01 quota 10M retention 7 day;
--创建一个默认的 Flashback Archive,配额 unlimited,数据保留期为 7 天 
SQL> create flashback archive fda02 tablespace fda02 retention 7 day;
（配额 unlimited，用户对该表空间的配额也必须为 ulimited）
若配合不够，则修改用户配额。 -> SQL> grant unlimited tablespace to XXXX;
--用户赋权
SQL> grant flashback archive administer to andy;
--查询 flashback archive 情况
SQL> select flashback_archive_name name, status from dba_flashback_archive;
--修改default flashback archive
SQL> alter flashback archive XXX set default;
--为已经存在的 Flashback Archive 添加表空间，并指定配额
SQL> alter flashback archive XXX add tablespace XXXX quota 100M;
--将表空间从 Flashback Archive 中移除
SQL> alter flashback archive XXX remove tablespace XXX;
--修改已经存在的 Flashback Archive 的配额
SQL> alter flashback archive fla1 modify tablespace XXX quota 30m;
--修改配额不受限制
SQL> alter flashback archive XXX modify tablespace XXX;
--修改 Flashback Archive 的 retention time
SQL> alter flashback archive fla1 modify retention 1 year;
--清空 Flashback Archive 中的所有历史记录
SQL> alter flashback archive XXX purge all;
--清空 Flashback Archive 中超过 1 天的历史数据
SQL> alter flashback archive fla1 purge before timestamp (systimestamp - interval '1'day);
--清空 Flashback Archive 中指定 SCN 之前的所有历史数据
SQL> alter flashback archive fla1 purge before scn XXX;
-- 删除 Flashback Archive 不会删除相应的表空间
SQL> DROP FLASHBACK ARCHIVE XXX;
```

### 操作流程：

```sql
--创建测试的 FDA 表空间
SQL>
create tablespace fda01 logging  datafile '/home/oracle/app/oradata/orcl/fda01.dbf' 
size 10m  autoextend on  next 1m maxsize 30m  extent management local; 
SQL>
create tablespace fda02 logging  datafile '/home/oracle/app/oradata/orcl/fda02.dbf' 
size 10m  autoextend on  next 1m maxsize 30m  extent management local; 

--创建一个默认的 Flashback Archive, 配额为 10M，数据保留期为 7 天
SQL> create flashback archive default fda01 tablespace fda01 quota 10M retention 7 day;
--创建一个默认的 Flashback Archive,配额 unlimited,数据保留期为 7 天 
SQL> create flashback archive fda02 tablespace fda02 retention 7 day;

--查询 flashback archive 情况
SQL> col name for a40
SQL> select flashback_archive_name name, status from dba_flashback_archive;

NAME                                     STATUS
---------------------------------------- -------
FDA01                                    DEFAULT
FDA02

--创建 table，使用默认的 Flashback Data Archive 来存储历史数据
SQL> create table fad01(id number) flashback archive;

--创建 table，使用指定的 Flashback Data Archive 来存储历史数据
SQL> create table fda02(id number) flashback archive fda02;

在 Flashback Area 中，会有一张历史表记录着我们启动 FA 表的所有操作。 我们可以通过如下 SQL 来查看他们之间的映射关系。
SQL>  SELECT  table_name,archive_table_name,status  from dba_flashback_archive_tables;

--对表启用 Flashback archive，并使用默认的 Flashback archive。
SQL> alter table XXX flashback archive;

--禁用表的 Flashback Archive
SQL> alter table XXX no flashback archive;

--对 table 启用 Flashback archive，并指定 Flashaback Archive 区。
SQL> alter table XXX flashback archive fla1;
```

## 针对 FDA 的DDL处理。

启动Flashback Data Archive的表上的一些DDL 操作可能触发ORA-55610的错误，DDL限制：
1）ALTER TABLE statement that includes an UPGRADE TABLE clause, withor without an INCLUDING DATA clause
2）ALTER TABLE statement that moves or exchanges a partition or subpartition operation
3）DROP TABLE statement


说明：
如果必须在已经启用 Flashback Archive 的表上执行这些不支持的 DDL 操作，可以用DBMS_FLASHBACK_ARCHIVE 包将表从Flashback Data Archive 分离出来，待操作结束后在添加进去。

--查询 FDA 的映射关系
SQL>  SELECT  table_name,archive_table_name,status  from dba_flashback_archive_tables;
我们要执行那些不支持的 DDL，就需要用 dbms_flashback_archive 禁用他们之间的映射关系，在操作，操作完在用该包启用他们。
--表的分离和重新结合
SQL> exec dbms_flashback_archive.disassociate_fba('ANDY','FAD01');
SQL> exec dbms_flashback_archive.reassociate_fba('ANDY','FAD01');

## Flashback Data Archive   恢复数据的测试流程：

```sql
--创建测试的 FDA 表空间
SQL>
create tablespace fda01 logging  datafile '/home/oracle/app/oradata/orcl/fda01.dbf' 
size 10m  autoextend on  next 1m maxsize 30m  extent management local; 
SQL>
create tablespace fda02 logging  datafile '/home/oracle/app/oradata/orcl/fda02.dbf' 
size 10m  autoextend on  next 1m maxsize 30m  extent management local; 

--创建一个默认的 Flashback Archive, 配额为 10M，数据保留期为 7 天
SQL> create flashback archive default fda01 tablespace fda01 quota 10M retention 7 day;
--创建一个默认的 Flashback Archive,配额 unlimited,数据保留期为 7 天 
SQL> create flashback archive fda02 tablespace fda02 retention 7 day;

--查询 flashback archive 情况
SQL> col name for a40
SQL> select flashback_archive_name name, status from dba_flashback_archive;

NAME                                     STATUS
---------------------------------------- -------
FDA01                                    DEFAULT
FDA02
--sys用户赋权
SQL> grant flashback archive administer to andy;
--创建测试表：
SQL> create table fad01(id number) flashback archive;
--插入数据：
SQL> insert into fad01 values(1);
SQL> select count(*) from fad01;
  COUNT(*)

    --查询时间：
    SQL> select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') tm from dual;
2015-03-15 05:35:40
在 update 一次数据：
SQL> update fad01 set id=11 where id =1;
SQL>commit;
查询时间：
SQL> select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') tm from dual;

2015-03-15 05:37:25
使用 Flashback Archive 查询 1 分钟之前的数据：
SQL> select count(*) from fad01 as of timestamp (systimestamp - interval '1'minute);

--删除表数据
SQL> delete from fad01;
SQL> commit;
SQL> select count(*) from fad01;
查询表映射关系
SQL> col TABLE_NAME for a10
SQL> col OWNER_NAME for a10
SQL>  col FLASHBACK_ARCHIVE_NAME for a15
SQL> SELECT * from dba_flashback_archive_tables;
TABLE_NAME OWNER_NAME FLASHBACK_ARCHI ARCHIVE_TABLE_NAME                     STATUS
---------- ---------- --------------- ---------------------------------- ---------------
FAD01      ANDY       FDA01           SYS_FBA_HIST_97516                    ENABLED
从这个结果，可以看出，在 Flashback archive 对应的 FAD01 表的历史表是 SYS_FBA_HIST_97516 。
该表保存了 FA 表的所有的操作记录：
SQL> select count(*) from SYS_FBA_HIST_97516;

注意：历史表只能查询，若想修改，必须解除映射关系。
```

______________________________________________

## 验证 FDA 与undo无关，新建 UDNO TBS并切换默认 UNDO TBS ,删除旧默认 UNDO TBS

```sql
1、创建新的undo表空间undotbs2
create undo tablespace UNDOTBS2  datafile '/home/oracle/app/oradata/orcl/undotbs02.dbf' 
size 50m  autoextend on  next 10m maxsize unlimited  extent management local; 
2、切换系统表空间
alter system set undo_tablespace=UNDOTBS2  scope=both;
3、删除原来undo内容
drop tablespace undotbs1 including contents and datafiles;
_____________________________________________
SQL> select * from fad01 as of timestamp  to_timestamp('2015-03-15 05:37:25','YYYY-MM-DD hh24:mi:ss');
        ID
----------
        11

-- 利用不受限于undo时间的，FDA 与 flashback query恢复误操作。
SQL> insert into fad01 select * from fad01 as of timestamp  to_timestamp('2015-03-15 05:37:25','YYYY-MM-DD hh24:mi:ss');
1 row created.

SQL> select * from fad01;
        ID
----------
        11

-- 删除 FDA 表
SQL> alter table fad01 no flashback archive;
Table altered.

SQL> drop table fad01;
Table dropped
```

# flashback（闪回）

## 闪回恢复区（FRA）

### 查看闪回恢复区大小

show parameter db_recover

### 查看闪回保留时间

show parameter db_flashback_retention_target

### 查看FRA里存放的数据类型、

select file_type from v$flash_recovery_area_usage;

### 查看归档参数

show parameter recovery

### 更改db_recovery_file_dest_size大小

alter system set db_recovery_file_dest_size=15000M;
show parameter retention
alter system set db_flashback_retention_target=3600
flashback query

### 开启闪回

archive log list
shutdown immediate
startup mount
alter database flashback on;
alter database oprn;
select flashback_on from v$database;

## 不同粒度级别的闪回

### 1，基于时间点闪回

flashback database to time="to_date('2013-05-16 12:00:00','yyyy-mm-dd hh24:mi:ss')";

### 2,基于时间戳，闪回到1小时之前

flashback database to timestamp(sysdata-1/24);

### 3,基于scn号闪回

flashback database to scn 1144328;

### 4,基于日志序号闪回

flashback database to sequence=1000 thread=1;

### 5,基于还原点闪回

flashback database to restore pointleo_point1;

### undo表空间retention guarantee

启用：alter tablespace undotbs1 retention guarantee;
禁用：alter tablespace undotbs1 retention noguarantee;

### recycle回收站

show　parameter recycle;

### 清除回收站空间

表空间的Recycle Bin 区域只是一个逻辑区域，而不是从表空间上物理的划出一块区域固定用于回收站，因此Recycle Bin是和普通对象共用表空间的存储区域，或者说是Recycle Bin的对象要和普通对象抢夺存储空间。当发生空间不够时，Oracle会按照先入先出的顺序覆盖Recycle Bin中的对象。也可以手动的删除Recycle Bin占用的空间。
可以手动的删除Recycle Bin占用的空间：
1). Purge tablespace tablespace_name: 用于清空表空间的Recycle Bin
2). Purge tablespace tablespace_nameuser user_name: 清空指定表空间的Recycle Bin中指定用户的对象
3). Purge recyclebin: 删除当前用户的Recycle Bin中的对象
4). Purge dba_recyclebin: 删除所有用户的Recycle Bin中的对象，该命令要sysdba权限
5). Drop table table_namepurge: 删除对象并且不放在Recycle Bin中，即永久的删除，不能用Flashback恢复。
6). Purge index recycle_bin_object_name：当想释放Recycle bin的空间，又想能恢复表时，
可以通过释放该对象的index所占用的空间来缓解空间压力。因为索引是可以重建的。