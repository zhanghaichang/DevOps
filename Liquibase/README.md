# Liquibase 

> iquibase 是一个用于跟踪，管理和应用数据库变化的开源的数据库重构工具。它将所有数据库的变化(包括结构和数据) 都保存在XML文件中，便于版本控制。liquibase说白了就是一个将你的数据库脚本转化为xml格式保存起来，其中包含了你对数据库的改变，以及数据库的版本信息，方便数据的升级和回滚等操作。


* 目前支持多种数据库，包括Oracle/SqlServer/DB2/MySql/Sybase/PostgreSQL/Cache 等。
* 提供数据库比较功能，比较结果保存在XML中，基于该XML你可用Liquibase轻松部署或升级数据库。
* 以XML存储数据库变化，其中以作者和ID唯一标识一个变化(changset)，支持数据库变化的合并，因此支持多开发人员同时合作。
* 在数据库中保存数据库修改历史(DatebaseChangeHistory)，在数据库升级时自动跳过以应用的变化(ChangSet)。
* 可生成数据库修改文档（HTML格式）。
* 提供数据重构的独立的IDE 和 Eclipse插件。
