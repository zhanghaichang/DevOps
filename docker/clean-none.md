# 清除无效images

### 先停止容器

```
docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }') 

```
### 删除容器
```
docker rm $(docker ps -a | grep "Exited" | awk '{print $1 }')  
```

### 再删除镜像
```
docker images|grep none|awk '{print $3}'|xargs docker rmi
```
