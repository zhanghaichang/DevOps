# 清除无效images

### 先停止

````
$ docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }')  //停止容器

```

### 再删除
```
docker images|grep none|awk '{print $3}'|xargs docker rmi
```
