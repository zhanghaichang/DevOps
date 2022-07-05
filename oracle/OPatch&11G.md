***************************************************
# 安装OPatch

```SHELL
*** 操作系统：RedHat linux                        
*** 数据库版本：11.2.0.4                          
*** 补丁版本：p26610246_112040_Linux-x86-64.zip  
*** OPatch版本：p6880880_112000_Linux-x86-64.zip  
```

***************************************************

## 1、安装OPatch

```SHELL
必须使用OPatch版本 11.2.0.3.6或更高的版本。
在每个节点都执行一遍。

在grid_home和oracle_home分别解压缩。
$ unzip <OPATCH-ZIP> -d <ORACLE_HOME>
$ <ORACLE_HOME>/OPatch/opatch version

OPatch目录的权限和数组与原来一样。

[grid@bdc1 OPatch]$ opatch version
OPatch Version: 11.2.0.3.4

OPatch succeeded.
[grid@bdc1 OPatch]$ opatch version
OPatch Version: 11.2.0.3.12
```

## 2、配置ocm

```SHELL
配置ocm.rsp文件，用grid用户创建ocm.rsp文件和执行以下命令
在每个节点都执行一遍
cd /u01/app/11.2.0/grid/OPatch/ocm
touch ocm.rsp
$ORACLE_HOME/OPatch/ocm/bin/emocmrsp -no_banner -output /u01/app/11.2.0/grid/OPatch/ocm/ocm.rsp
```

## 3、查看补丁更新情况

```SHELL
$ORACLE_HOME/OPatch/opatch lsinventory -detail -oh $ORACLE_HOME
```

## 4、解压缩补丁文件

用grid用户解压缩补丁文件
将补丁文件目录改成grid:oinstall

在每个节点执行一遍。

## 5、更新补丁

```SHELL
用root用户执行以下脚本：
/u01/app/11.2.0/grid/OPatch/opatch auto 26610246 -ocmrf /u01/app/11.2.0/grid/OPatch/ocm/ocm.rsp

在每个节点执行一遍
```

## 6、如果数据库已创建，在一个节点上执行一遍即可

```SHELL
cd $ORACLE_HOME/rdbms/admin
sqlplus /nolog
```

```SQL
SQL> CONNECT / AS SYSDBA
SQL> STARTUP
SQL> @catbundle.sql psu apply
SQL> QUIT
The catbundle.sql execution is reflected in the dba_registry_history view by a row associated with bundle series PSU.
For information about the catbundle.sql script, see My Oracle Support Document 605795.1 Introduction to Oracle Database catbundle.sql.
```

## 7、查看数据补丁更新情况

```SQL
select * from dba_registry_history;
```



# opatch

## oracle11.2.0.4 打psu升级到11.2.0.4.6    RAC

### 查看失效对象

```SQL
SELECT owner,object_name,object_type,status
from dba_objects
where status = 'INVALID';
```

### 1、升级grid和oracle的opatch

 可以将opatch的版本升级到最高
最新版本的oracle软件opatch：https://updates.oracle.com/download/6880880.html  (oracle和grid都用这个opatch)
最新版本的grid软件opatch：https://updates.oracle.com/download/16083653.html
分别给grid和oracle用户配置环境变量 $ORACLE_HOME/OPatch 这样grid和oracle用户都能执行opatch命令
更新opatch之前先将$ORACLE_HOME/OPatch  目录备份一下，然后直接将解压的OPatch目录copy到$ORACLE_HOME目录即可  
更新完成后检查opatch版本，分别用grid用户和oracle用户执行opatch version 或者 opatch lsinventory

### 2、下载db psu和 gi psu

Metalink 的ID号为：753736.1
找到11.2.0.4版本数据库，这里下载了GI PSU：p20485808       DB PSU：p20299013

### 3、配置OCM

```SHELL
使用grid用户：
[grid@liurh1 bin]$ cd /u01/app/11.2.0/grid/OPatch/ocm/bin

[grid@liurh1 bin]$ /u01/app/11.2.0/grid/OPatch/ocm/bin/emocmrsp 
OCM Installation Response Generator 10.3.7.0.0 - Production
Copyright (c) 2005, 2012, Oracle and/or its affiliates.  All rights reserved.

Provide your email address to be informed of security issues, install and
initiate Oracle Configuration Manager. Easier for you if you use your My
Oracle Support Email address/User Name.
Visit http://www.oracle.com/support/policies.html for details.
Email address/User Name: 

You have not provided an email address for notification of security issues.
Do you wish to remain uninformed of security issues ([Y]es, [N]o) [N]:  y
The OCM configuration response file (ocm.rsp) was successfully created.
[grid@liurh1 bin]$ ls
emocmrsp  ocm.rsp   ---可以看到在/u01/app/11.2.0/grid/OPatch/ocm/bin 目录生成了ocm.rsp文件
```

### 4、升级Oracle Gird Infrastructure（GI） 

#### 4.1 节点一安装psu

在grid用户的$ORACLE_BASE目录下创建了一个新目录opatch，将下载的psu解压到该目录
安装前检查：[grid@liurh1 opatch]$ opatch lsinventory -detail -oh  $ORACLE_HOME  
升级psu：此处必须用root用户执行，解压后的软件必须是 grid:oinstall  组权限，执行安装时候要一个一个节点安装，不要并行执行
官方手册：# opatch auto <UNZIPPED_PATCH_LOCATION>/20485808 -ocmrf <ocm response file>

```SHELL
[root@liurh1 opatch]# /u01/app/11.2.0/grid/OPatch/opatch  auto /u01/app/grid/opatch/20485808/ -ocmrf  /u01/app/11.2.0/grid/OPatch/ocm/bin/ocm.rsp 
Executing /u01/app/11.2.0/grid/perl/bin/perl /u01/app/11.2.0/grid/OPatch/crs/patch11203.pl -patchdir /u01/app/grid/opatch -patchn 20485808 -ocmrf /u01/app/11.2.0/grid/OPatch/ocm/bin/ocm.rsp -paramfile /u01/app/11.2.0/grid/crs/install/crsconfig_params

This is the main log file: /u01/app/11.2.0/grid/cfgtoollogs/opatchauto2016-03-25_14-36-10.log

This file will show your detected configuration and all the steps that opatchauto attempted to do on your system:
/u01/app/11.2.0/grid/cfgtoollogs/opatchauto2016-03-25_14-36-10.report.log

2016-03-25 14:36:10: Starting Clusterware Patch Setup
Using configuration parameter file: /u01/app/11.2.0/grid/crs/install/crsconfig_params

Stopping RAC /u01/app/oracle/product/11.2.0/dbhome_1 ...
Stopped RAC /u01/app/oracle/product/11.2.0/dbhome_1 successfully

patch /u01/app/grid/opatch/20485808/20299013  apply successful for home  /u01/app/oracle/product/11.2.0/dbhome_1 
patch /u01/app/grid/opatch/20485808/20420937/custom/server/20420937  apply successful for home  /u01/app/oracle/product/11.2.0/dbhome_1 

Stopping CRS...
Stopped CRS successfully

patch /u01/app/grid/opatch/20485808/20299013  apply successful for home  /u01/app/11.2.0/grid 
patch /u01/app/grid/opatch/20485808/20420937  apply successful for home  /u01/app/11.2.0/grid 
patch /u01/app/grid/opatch/20485808/20299019  apply successful for home  /u01/app/11.2.0/grid 

Starting CRS...
Installing Trace File Analyzer
CRS-4123: Oracle High Availability Services has been started.

Starting RAC /u01/app/oracle/product/11.2.0/dbhome_1 ...
Started RAC /u01/app/oracle/product/11.2.0/dbhome_1 successfully
```

#### 4.2 节点二安装psu

节点一执行完之后，节点二才能执行

#### 4.3执行catbundle.sql 脚本

```SHELL
使用oracle用户随便在一个节点执行即可，cd $ORACLE_HOME/rdbms/admin
```

```SQL
sqlplus / as sysdba
SQL> @catbundle.sql psu apply
```

#### 4.4 检查GI PSU升级信息

```SHELL
[grid@liurh1 ~]$ opatch lsinventory -detail -oh $ORACLE_HOME |grep -i patch
select * from dba_registry_history
```

### 5、升级Oracle DB PSU

这里使用oracle用户分别在$ORACLE_BASE目录下建立一个opatch目录，将下载的db PSU上传到目录下解压，一个一个节点的去升级psu
（打psu之前关闭节点一，打完之后手动启动节点一，然后关闭节点二，给节点二打psu，之后启动节点二）

#### 5.1 节点一打PSU

```SHELL
[oracle@liurh1 20299013]$ srvctl stop instance -d racdb -i racdb1

-----检测补丁冲突------
unzip p24006111_112040_<platform>.zip
cd 24006111
opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir ./


[oracle@liurh1 20299013]$cd /u01/app/oracle/opatch/20299013

[oracle@liurh1 20299013]$ opatch apply
Oracle Interim Patch Installer version 11.2.0.3.12
Copyright (c) 2016, Oracle Corporation.  All rights reserved.


Oracle Home       : /u01/app/oracle/product/11.2.0/dbhome_1
Central Inventory : /u01/app/oraInventory
   from           : /u01/app/oracle/product/11.2.0/dbhome_1/oraInst.loc
OPatch version    : 11.2.0.3.12
OUI version       : 11.2.0.4.0
Log file location : /u01/app/oracle/product/11.2.0/dbhome_1/cfgtoollogs/opatch/opatch2016-03-25_15-47-22PM_1.log

Verifying environment and performing prerequisite checks...
All of the sub-patch(es) of the composite patch are already installed in the Oracle Home. No need to apply this patch.
Log file location: /u01/app/oracle/product/11.2.0/dbhome_1/cfgtoollogs/opatch/opatch2016-03-25_15-47-22PM_1.log

OPatch succeeded.

[oracle@liurh1 20299013]$ srvctl start instance -d racdb -i racdb1
```

#### 5.2 节点二打PSU（同节点一）

#### 5.3 升级catbundle（使用oracle用户在一个节点运行即可）

```SHELL
cd $ORACLE_HOME/rdbms/admin
sqlplus /  as sysdba
```

```SQL
SQL> @catbundle.sql psu apply
```

#### 5.4 检查DB PSU升级信息

```SQL
select * from dba_registry_history
```

### 6、总结，仔细阅读readme.html官方文档

### 7、aix安装oracle11.2.0.4-psu报错

```SHELL
/u01/app/grid/grid_home/OPatch/opatch auto /opatch/grid/24436338/ -ocmrf /u01/app/grid/grid_home/OPatch/ocm/bin/ocm.rsp

Executing /u01/app/grid/grid_home/perl/bin/perl /u01/app/grid/grid_home/OPatch/crs/patch11203.pl -patchdir /opatch/grid -patchn 24436338 -ocmrf /u01/app/grid/grid_home/OPatch/ocm/bin/ocm.rsp -paramfile /u01/app/grid/grid_home/crs/install/crsconfig_params

This is the main log file: /u01/app/grid/grid_home/cfgtoollogs/opatchauto2017-02-28_10-44-51.log

This file will show your detected configuration and all the steps that opatchauto attempted to do on your system:
/u01/app/grid/grid_home/cfgtoollogs/opatchauto2017-02-28_10-44-51.report.log

2017-02-28 10:44:51: Starting Clusterware Patch Setup
Using configuration parameter file: /u01/app/grid/grid_home/crs/install/crsconfig_params
The opatch minimum version  check for patch /opatch/grid/24436338/24006111 failed  for /u01/app/grid/grid_home
The opatch minimum version  check for patch /opatch/grid/24436338/23054319 failed  for /u01/app/grid/grid_home
The opatch minimum version  check for patch /opatch/grid/24436338/22502505 failed  for /u01/app/grid/grid_home
Opatch version check failed for oracle home  /u01/app/grid/grid_home
Opatch version  check failed
ERROR: update the opatch version for the failed homes and retry

解决方法，使用root用户：
cd /u01/app/grid/grid_home
mkdir .patch_storage
chown -R grid:oinstall .patch_storage
chmod -R 777 .patch_storage
```

#### -----单给oracle软件打补丁--------

```SHELL
在一个节点操作即可
1，在oracle用户oracle_home/OPatch/ocm/bin下生成ocm.rsp
2，unzip p202999013_xxxxxxx.zip
     cd 20299013
     opatch prereq CheckConflictAgainstOHWithDetail -ph ./
     opatch apply
     到2节点执行
     cd /u01/app/oracle/product/11.2.0.4/rdbms/lib; /usr/ccs/bin/make -f ins_rdbms.mk client_sharedlib ORACLE_HOME=/u01/app/oracle/product/11.2.0.4 || echo REMOTE_MAKE_FAILED::>&2 
cd /u01/app/oracle/product/11.2.0.4/rdbms/lib; /usr/ccs/bin/make -f ins_rdbms.mk iamdu ORACLE_HOME=/u01/app/oracle/product/11.2.0.4 || echo REMOTE_MAKE_FAILED::>&2 
..................................................
.................................................
cd /u01/app/oracle/product/11.2.0.4/ldap/lib; /usr/ccs/bin/make -f ins_ldap.mk ldapaddmt ORACLE_HOME=/u01/app/oracle/product/11.2.0.4 || echo REMOTE_MAKE_FAILED::>&2 
cd /u01/app/oracle/product/11.2.0.4/ldap/lib; /usr/ccs/bin/make -f ins_ldap.mk ldapadd ORACLE_HOME=/u01/app/oracle/product/11.2.0.4 || echo REMOTE_MAKE_FAILED::>&2
```

```SQL
3,如果已经没有建库，执行到上一步建库即可
   如果已经有库则执行以下脚本
   cd $ORACLE_HOME/rdbms/admin
sqlplus /nolog
SQL> CONNECT / AS SYSDBA
SQL> STARTUP
SQL> @catbundle.sql psu apply
SQL> QUIT
```

