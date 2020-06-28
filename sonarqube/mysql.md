# SoanrQube Mysql 数据源

登录 MySQL

`mysql -u root -p`

输入密码：123456

创建 Sonar 数据库

`create database sonar;`

添加远程登录用户：sonar ，并授予权限。

`CREATE USER 'sonar'@'%' IDENTIFIED WITH mysql_native_password BY 'sonar';`

`GRANT ALL PRIVILEGES ON *.* TO 'sonar'@'%';`

退出 MySQL

`exit`

