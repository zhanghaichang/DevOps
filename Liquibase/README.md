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

### 设置liquibase.properties文件

1.教程使用CLI。虽然可以传递所有必需的参数（如JDBC驱动程序和数据库URL），但配置 liquibase.properties文件会更容易节省时间和精力。

2.创建一个 liquibase.properties。将以下内容添加到文件中，并将其保存在您解压Liquibase *zip 或 *.tar.gz的产生的目录中。

```xml
driver: org.h2.Driver
classpath: ./h2-1.4.199.jar
url: jdbc:h2:file:./h2tutorial
username: admin
password: password
changeLogFile: myChangeLog.xml
```

### 使用 SQL 脚本

1. 第一步创建一个sql文件夹

在解压的Liquibase 的文件夹中 ，创建一个 sql 文件夹。在这个文件夹中你将放置 Liquibase将跟踪、版本和部署的SQL脚

2. 第二步建立一个Change Log

这是一次性步骤，用于配置更改日志以指向将包含 SQL 脚本的 sql 文件夹。在解压的*.zip 或*.tar.gz的 Liquibase 的目录中创建并保存文件名为 myChangeLog.xml 的文件 。myChangeLog.xml 的内容应如下所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
  xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
         http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-3.1.xsd">

  <includeAll path="/sql"/>
</databaseChangeLog>
```

3. 第3步在SQL文件中新增一个SQL脚本

使用教程设置中的 liquibase.properties 文件以及新创建的myChangeLog.xml，我们现在已准备好开始向 sql文件夹添加SQL脚本。Liquibase 将在文件夹中按字母数字顺序排列脚本。使用以下内容创建 001_create_person_table.sql 并将其保存在 sql文件夹中：

```sql
create table PERSON (
    ID int not null,
    FNAME varchar(100) not null
);

```

4. 第4步 部署你的第一个修改

现在，我们已准备好部署我们的第一个脚本！打开终端，如果在 UNIX系统上则运行 ./liquibase update或 如果在 Windows 上则运行liquibase.bat update。

5. 第5步 检查你的数据库

您将看到您的数据库现在包含一个名为PERSON的表。要将作为本教程一部分的 H2 数据库写入内容，请打开一个终端，导航到您提取的 Liquibase``*.zip 或 *.tar.gz的文件夹，并运行 java -jar h2-1.4.199.jar注意：输入您下载的 h2*.jar 的特定版本！输入JDBC URL、用户名和密码，从 liquibase.properties 文件输入您根据教程设置创建的属性文件。您会注意到还创建了另外两个表：databasechangeloglock和databasechangeloglock。databasechangelog表包含针对数据库运行的所有更改的列表。databasechangeloglock表用于确保两台计算机不会同时尝试修改数据库。

```

```
### Liquibase编写规范：

* Changset 的id使用【任务ID】+【日期】+【序号的方式】一般为了简单直接使用日期加序号即可，
* 写上作者，为了以后更改时候确认功能
* Liquibase禁止对业务数据进行操作
* Liquibase禁止使用存储过程
* Liquibase所有的表都加remarks注释
* 已经执行的ChangeSet严禁修改
* 不要随意的升级Liquibase的版本，不同的版本ChangeSet的MD5SUM的算法不一样
 
