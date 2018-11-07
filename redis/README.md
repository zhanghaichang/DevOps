# Redis install


## 本地文件安装

```
$ wget http://download.redis.io/releases/redis-4.0.11.tar.gz
$ tar xzf redis-4.0.11.tar.gz
$ cd redis-4.0.11
$ make
```

Run Redis with:
```
$ nohup src/redis-server &
```

You can interact with Redis using the built-in client:
```
$ src/redis-cli
redis> set foo bar
OK
redis> get foo
"bar"
```
## docker 单机安装

拉镜像

```
$ docker pull redis:4.0.11
```
配置持久化方式启动

```
$ docker run --name some-redis -v /docker/host/redis:/data -d redis redis-server --appendonly yes
```

自定义 redis.conf

```
$ docker run -v /data/redis/redis.conf:/usr/local/etc/redis/redis.conf --name myredis redis:4.0.11 redis-server /usr/local/etc/redis/redis.conf
```
自己用的 启动方式

```
$ docker run -d -v /data/redis/redis.conf:/usr/local/etc/redis/redis.conf -v /data/redis:/data -p 66379:6379  -d --restart=always --network=hydra_work --name redis-4.0.11 redis:4.0.11 redis-server /usr/local/etc/redis/redis.conf

```
