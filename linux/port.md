## Linux如何查看端口状态
```
netstat命令各个参数说明如下：

　　-t : 指明显示TCP端口

　　-u : 指明显示UDP端口

　　-l : 仅显示监听套接字(所谓套接字就是使应用程序能够读写与收发通讯协议(protocol)与资料的程序)

　　-p : 显示进程标识符和程序名称，每一个套接字/端口都属于一个程序。

　　-n : 不进行DNS轮询，显示IP(可以加速操作)
```
## 即可显示当前服务器上所有端口及进程服务，于grep结合可查看某个具体端口及服务情况··

netstat -ntlp   //查看当前所有tcp端口·

netstat -ntulp |grep 80   //查看所有80端口使用情况·

netstat -an | grep 3306   //查看所有3306端口使用情况·

## 查看一台服务器上面哪些服务及端口

netstat  -lanp

## 查看一个服务有几个端口。比如要查看mysqld

ps -ef |grep mysqld

## 查看某一端口的连接数量,比如3306端口

netstat -pnt |grep :3306 |wc

## 查看某一端口的连接客户端IP 比如3306端口

netstat -anp |grep 3306

netstat -an 查看网络端口 

lsof -i :port，使用lsof -i :port就能看见所指定端口运行的程序，同时还有当前连接。 

## nmap 端口扫描
netstat -nupl  (UDP类型的端口)
netstat -ntpl  (TCP类型的端口)
netstat -anp 显示系统端口使用情况
