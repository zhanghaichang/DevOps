# Mysql docker install

拉镜像
```
$ docker pull mysql:5.7
```

运行
```
$ sudo docker run --name first-mysql -p 3306:3306 -e MYSQL\_ROOT\_PASSWORD=123456 -d mysql

```
持久化运行

```
$ sudo docker run --name mysql -p 3306:3306 -v /docker/data/mysql:/var/lib/mysql -e MYSQL\_ROOT\_PASSWORD=topcheer123 -d mysql:5.7
```


## mysql run 

```
mysql -h localhost -P端口 -u root -p 123456 

```
