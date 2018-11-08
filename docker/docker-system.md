## Docker System命令

docker system df命令，类似于Linux上的df命令，用于查看Docker的磁盘使用情况：

```
docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              147                 36                  7.204GB             3.887GB (53%)
Containers          37                  10                  104.8MB             102.6MB (97%)
Local Volumes       3                   3                   1.421GB             0B (0%)
Build Cache                                                 0B                  0

```

可知，Docker镜像占用了7.2GB磁盘，Docker容器占用了104.8MB磁盘，Docker数据卷占用了1.4GB磁盘。

`docker system prune` 命令可以用于清理磁盘，删除关闭的容器、无用的数据卷和网络，以及dangling镜像（即无tag的镜像）。
`docker system prune -a` 

命令清理得更加彻底，可以将没有容器使用Docker镜像都删掉。注意，这两个命令会把你暂时关闭的容器，以及暂时没有用到的Docker镜像都删掉了……所以使用之前一定要想清楚吶。

执行`docker system prune -a`命令之后，Docker占用的磁盘空间减少了很多：

```
docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              10                  10                  2.271GB             630.7MB (27%)
Containers          10                  10                  2.211MB             0B (0%)
Local Volumes       3                   3                   1.421GB             0B (0%)
Build Cache                                                 0B                  0B

```
### 手动清理Docker镜像/容器/数据卷

对于旧版的Docker（版本1.13之前），是没有Docker System命令的，因此需要进行手动清理。这里给出几个常用的命令：

#### 删除所有关闭的容器：
```
docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm
```
#### 删除所有dangling镜像（即无tag的镜像）：
```
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
```
#### 删除所有dangling数据卷（即无用的Volume）
```
docker volume rm $(docker volume ls -qf dangling=true)
```


### 空间清理

Docker 使用过程中，可能会发现宿主节点的磁盘容量持续增长，譬如 volume 或者 overlay2 目录占用了大量的空间；如果任其发展，可能将磁盘空间耗尽进而引发宿主机异常，进而对业务造成影响。Docker 的内置 df 指令可用于查询镜像（Images）、容器（Containers）和本地卷（Local Volumes）等空间使用大户的空间占用情况。而容器的占用的总空间，包含其最顶层的读写层（writable layer）和底部的只读镜像层（base image layer，read-only），我们可以使用 ps -s 参数来显示二者的空间占用情况：

```
# 查看当前目录下的文件空间占用
$ du -h --max-depth=1 | sort

# 空间占用总体分析
$ docker system df

# 输出空间占用细节
$ docker system df -v

# 输出容器的空间占用
$ docker ps -s
```
docker system prune 指令能够进行自动地空间清理，其默认会清除已停止的容器、未被任何容器所使用的卷、未被任何容器所关联的网络、所有悬空镜像：

```
# 一并清除所有未使用的镜像和悬空镜像
$ docker system prune --all

# 列举悬空镜像
$ docker images -f dangling=true

# 删除全部悬空镜像
$ docker image prune
# 删除所有未被使用的镜像
$ docker image prune -a

# 删除指定模式的镜像
$ docker images -a | grep "pattern" | awk '{print $3}' | xargs docker rmi

# 删除全部镜像
$ docker rmi $(docker images -a -q)

# 删除全部停止的容器
$ docker rm $(docker ps -a -f status=exited -q)

# 根据指定模式删除容器
$ docker rm $(docker ps -a -f status=exited -f status=created -q)
$ docker rm $(docker ps -a | grep rabbitmq | awk '{print $1}')

# 删除全部容器
$ docker stop $(docker ps -a -q)
$ docker rm $(docker ps -a -q)

# 列举并删除未被使用的卷
$ docker volume ls -f dangling=true
$ docker volume prune

# 根据指定的模式删除卷
$ docker volume prune --filter "label!=keep"

# 删除未被关联的网络
$ docker network prune
$ docker network prune --filter "until=24h"
复制代码我们也可以手动指定日志文件的尺寸或者清空日志文件:
# 设置日志文件最大尺寸
$ dockerd ... --log-opt max-size=10m --log-opt max-file=3

# 清空当前日志文件
truncate -s 0 /var/lib/docker/containers/*/*-json.log

```
