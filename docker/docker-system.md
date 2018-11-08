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

docker system prune命令可以用于清理磁盘，删除关闭的容器、无用的数据卷和网络，以及dangling镜像（即无tag的镜像）。docker system prune -a命令清理得更加彻底，可以将没有容器使用Docker镜像都删掉。注意，这两个命令会把你暂时关闭的容器，以及暂时没有用到的Docker镜像都删掉了……所以使用之前一定要想清楚吶。

执行docker system prune -a命令之后，Docker占用的磁盘空间减少了很多：

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
