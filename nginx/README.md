# Nginx



## Ngnix中location与proxy_pass配置规则总结


### 1.location匹配变量与配置格式

https://blog.csdn.net/oMaoYanEr/article/details/82557764


### nginx常用命令  

```

    nginx -s quit         优雅停止nginx，有连接时会等连接请求完成再杀死worker进程  

    nginx -s reload     优雅重启，并重新载入配置文件nginx.conf

    nginx -s reopen     重新打开日志文件，一般用于切割日志

    nginx -v            查看版本  

    nginx -t            检查nginx的配置文件

    nginx -h            查看帮助信息

 　 nginx -V       详细版本信息，包括编译参数 

    nginx  -c filename  指定配置文件

```
