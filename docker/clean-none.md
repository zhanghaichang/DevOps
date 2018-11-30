# 清除无效images

### 1.先停止容器

```
docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }') 

```
### 2.删除容器
```
docker rm $(docker ps -a | grep "Exited" | awk '{print $1 }')  
```

### 3.删除镜像
```
docker images|grep none|awk '{print $3}'|xargs docker rmi
```
