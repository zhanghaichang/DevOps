# Docker  admin


```
docker run -d -p 8280:8080 --name dubbo -e dubbo.registry.address=zookeeper://172.16.223.132:2181 -e dubbo.admin.root.password=root chenchuxin/dubbo-admin
```
