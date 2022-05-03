################################ 准备工作
# 这里我们假设：
#	1. 操作目录：C:\Users\{User}\Desktop\liquibase\
#	2. liquibase-4.1.0-bin目录：D:\liquibase-4.1.0\
# 将 liquibase.properties ， changelog-dsl-xml-table.xml, mysql-connector-java-8.0.13.jar 放置到 C:\Users\{User}\Desktop\liquibase\ 下。

# liquibase.properties中的内容
	driver: com.mysql.jdbc.Driver
	classpath: ./mysql-connector-java-8.0.13.jar
	url: jdbc:mysql://81.68.158.66:3307/kqauth?useUnicode=true&characterEncoding=UTF-8
	username: root
	password: 123456    

# 打开powershell, 切换到操作目录
cd C:\Users\{User}\Desktop\liquibase\

################################ 常用操作
# dbDoc ： 生成数据库结构文档 ( 经过简单测试：changeLogFile参数对生成的文档没有影响，但又必须要 )
java -jar D:\liquibase-4.1.0\liquibase.jar dbDoc D:/liquibase/ --logLevel=error --changeLogFile=changelog-dsl-xml-table.xml

# update : 执行某个changelog
java -jar D:\liquibase-4.1.0\liquibase.jar --changeLogFile=changelog-dsl-xml-table.xml update

# 逆向工程 - 生成当前数据库的changeset, 默认是生成数据库结构, 不包含数据
java -jar D:\liquibase-4.1.0\liquibase.jar --changeLogFile=generateChangeLog.xml generateChangeLog
# 逆向工程 - 生成当前数据库的changeset, 只包含数据; diffTypes的可选值可参照文档.
java -jar D:\liquibase-4.1.0\liquibase.jar --changeLogFile=generateChangeLog-data.xml  --diffTypes="data" generateChangeLog

# 对比两个数据库结构, 最终结果存放在指定位置. 
# 注意最终的结果反映的是由源数据库结构变成目标数据库结构(由referenceUrl指示), 需要作出哪些变化.
java -jar D:\liquibase-4.1.0\liquibase.jar --referenceUrl=jdbc:mysql://81.68.158.66:3306/kqauth --referenceUsername=root --referencePassword=123456 --changeLogFile=D:/111.xml --diffTypes="data" diff
