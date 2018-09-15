# 消息队列 


## rabbitmq

持久化 启动

```
$ docker run  -p 5671:5671 -p 5672:5672  -p 15672:15672 -p 15671:15671  -p 25672:25672  -v /docker/host/rabbitmq:/var/rabbitmq/lib  --name rabbitmq -d rabbitmq 
```

成功创建容器后，就可以访问web 管理端了
> http://127.0.0.1:15672
默认创建了一个 guest 用户，密码也是 guest。 
