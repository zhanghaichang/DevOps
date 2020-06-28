# SoanrQube 切换Mysql数据源

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

### 配置迁移

```
使用 scp 命令，将重要文件复制到本机的 /data/sonarqube/ 下

scp -r conf/ data/ extensions/ logs/ root@10.9.40.121:/data/sonarqube

命令解释： 将 conf/ data/ extensions/ logs/ 复制到 /data/sonarqube 目录下

scp 是 SSH cp。用户为 root，主机号为 10.9.40.121。

输入 yes，输入 root 的密码
```

递归修改文件夹权限

`chmod -R 777 /data/sonarqube/`


### 启动 Sonar

```shell
docker run \
 -d \
 --name sonarqube \
 -p 9000:9000 \
 -p 9092:9092 \
 -v /data/sonarqube/logs:/opt/sonarqube/logs \
 -v /data/sonarqube/conf:/opt/sonarqube/conf \
 -v /data/sonarqube/data:/opt/sonarqube/data \
 -v /data/sonarqube/extensions:/opt/sonarqube/extensions \
 -e SONARQUBE_JDBC_USERNAME=sonar \
 -e SONARQUBE_JDBC_PASSWORD=sonar \
 -e SONARQUBE_JDBC_URL="jdbc:mysql://xx.xx.xx.xx:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false" \
 sonarqube:7.4-community


```

