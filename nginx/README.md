# Nginx 安装

> NGINX是一个免费、开源、高性能、轻量级的HTTP和反向代理服务器，也是一个电子邮件（IMAP/POP3）代理服务器，其特点是占有内存少，并发能力强。 Nginx 因为它的稳定性、丰富的模块库、灵活的配置和较低的资源消耗而闻名 。目前应该是几乎所有项目建设必备。

```
wget http://nginx.org/download/nginx-1.16.1.tar.gz 
```
安装需要编译的插件

* 用于编译c、c++代码的GCC；

* 用c语言编写的正则表达式函数库Pcre(使用rewrite模块)；

* 用于数据压缩的函式库的Zlib；

* 安全套接字层密码库OpenSSL（启用SSL支持）

```
yum install gcc c++                                          
yum install -y pcre pcre-devel                          
yum install -y zlib zlib-devel                           
yum install -y openssl openssl-devel   

```
解压、配置（Nginx支持各种配置选项,文末一一列出 Nginx配置选项 ）、编译、安装nginx

```
tar -zxvf nginx-1.15.tar.gz cd nginx-1.16.1
cd nginx-1.16.1
./configure
make && sudo make install 

```
启动、重启、关闭

```
cd /usr/local/nginx/ 
cd sbin
./nginx
#关闭命令 
./nginx -s stop
#重启，热部署
./nginx -s reload
#修改配置文件后也别嘚瑟，反正我会动不动就写错，检查修改的nginx.conf配置是否正确
./nginx -t

```


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
### Nginx配置解决跨域问题
```
location / {
   add_header Access-Control-Allow-Origin *;
   add_header Access-Control-Allow-Headers X-Requested-With;
   add_header Access-Control-Allow-Methods GET,POST,PUT,DELETE,OPTIONS;

   if ($request_method = 'OPTIONS') {
     return 204;
   }
}
```
