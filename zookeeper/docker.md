# zookeeper Docker 单机

### 下载Zookeeper镜像

```shell
docker pull zookeeper
```
### docker run 

```shell
docker run --privileged=true -d --name zookeeper --restart always --publish 2181:2181  -d zookeeper:latest
```
持久化

```shell
docker run --privileged=true -d --name zookeeper --restart always --publish 2181:2181 -v $PWD/data:/data -d zookeeper:latest
```

