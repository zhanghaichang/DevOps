# Liquibase 

> iquibase 是一个用于跟踪，管理和应用数据库变化的开源的数据库重构工具。它将所有数据库的变化(包括结构和数据) 都保存在XML文件中，便于版本控制。liquibase说白了就是一个将你的数据库脚本转化为xml格式保存起来，其中包含了你对数据库的改变，以及数据库的版本信息，方便数据的升级和回滚等操作。

### 1. Liquibase 特性

* 目前支持多种数据库，包括Oracle/SqlServer/DB2/MySql/Sybase/PostgreSQL/Cache 等。
* 提供数据库比较功能，比较结果保存在XML中，基于该XML你可用Liquibase轻松部署或升级数据库。
* 以XML存储数据库变化，其中以作者和ID唯一标识一个变化(changset)，支持数据库变化的合并，因此支持多开发人员同时合作。
* 在数据库中保存数据库修改历史(DatebaseChangeHistory)，在数据库升级时自动跳过以应用的变化(ChangSet)。
* 可生成数据库修改文档（HTML格式）。
* 提供数据重构的独立的IDE 和 Eclipse插件。

### 2.Liquibase 支持集成的方式有多种

* Command 命令行模式
* Maven
* Ant
* Spring Boot

### 3. Liquibase原理
无论哪种集成方式，都是通过编写存储变更的changelog文件来实现的，一般放在CLASSPATH下，然后配置到执行路径中。目前 Liquibase 支持 XML、YAML、JSON 和 SQL 格式四种格式的 changelog 文件。


### 安装

1.下载、解压Liquibase： https://download.liquibase.org ，下载好*.zip或者*.tar.gz文件后，解压里面的内容到一个文件夹。
2.安装java（配置环境变量）  
3.下载数据库驱动包放到Liquibase目录下的lib  


### Liquibase编写规范：

* Changset 的id使用【任务ID】+【日期】+【序号的方式】一般为了简单直接使用日期加序号即可，
* 写上作者，为了以后更改时候确认功能
* Liquibase禁止对业务数据进行操作
* Liquibase禁止使用存储过程
* Liquibase所有的表都加remarks注释
* 已经执行的ChangeSet严禁修改
* 不要随意的升级Liquibase的版本，不同的版本ChangeSet的MD5SUM的算法不一样
 
