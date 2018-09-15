# Mysql docker install

拉镜像
```
$ docker pull mysql:5.6
```

运行
```
$ sudo docker run --name first-mysql -p 3306:3306 -e MYSQL\_ROOT\_PASSWORD=123456 -d mysql

```
持久化运行

```
$ sudo docker run --name mysql -p 3306:3306 -v /docker/host/mysql:/var/lib/mysql -e MYSQL\_ROOT\_PASSWORD=123456 -d mysql:5.6
```
