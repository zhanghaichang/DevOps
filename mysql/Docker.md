# Mysql docker install

拉镜像
```
$ docker pull mysql:5.7
```

运行
```
$ sudo docker run --name first-mysql -p 3306:3306 -e MYSQL\_ROOT\_PASSWORD=123456 -d mysql

```
配置文件映射 不区分大小写

```
# 持久化存储
docker run --name mysql -p 30006:3306 -v /data/k8s/mysql:/var/lib/mysql -e MYSQL\_ROOT\_PASSWORD=topcheer123 -d mysql:5.7.14 --lower_case_table_names=1


docker run -p 3306:3306 --name mysql \
       -v /data/mysql/conf:/etc/mysql/conf.d \
       -v /data/mysql/logs:/logs \
       -v /data/mysql:/mysql_data \
       -e MYSQL_ROOT_PASSWORD=123456 \
       -d mysql:5.7.14 \
       --lower_case_table_names=1
```
-d ： 后台运行容器，并返回容器 ID

-p 3307:3306 ： 将容器的 3307 端口映射到主机的 3306 端口

–name mysql ： 命名为 mysql

-v /data/mysql/conf:/etc/mysql/conf.d ： 将本机 /data/mysql/conf/my.cnf 挂载到容器的 /etc/mysql/my.cnf

-v /data/mysql/logs:/logs ： 将本机 /data/mysql/logs 目录挂载到容器的 /logs

-v /data/mysql/data:/var/lib/mysql ： 将本机 /data/mysql/data 目录挂载到容器的 /var/lib/mysql

-e MYSQL_ROOT_PASSWORD=123456 ： 初始化 root 用户，密码设置为 123456


## 持久化运行

```
$ sudo docker run --name mysql -p 3306:3306 -v /docker/data/mysql:/var/lib/mysql -e MYSQL\_ROOT\_PASSWORD=topcheer123 -d mysql:5.7
```


## mysql run 

```
mysql -h localhost -P端口 -u root -p 123456 

```
