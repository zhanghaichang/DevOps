## oracle 安装


## oracle clinet 安装

https://www.oracle.com/technetwork/database/database-technologies/instant-client/downloads/index.html


## linux下面查看链接个数

得到processid
> 
ps aux|grep <your java name>
查看链接数据库的链接
> netstat -apn|grep <your processid>
  
可以看到具体的链接的个数，用来检验是否你的链接池是正确的

## 分区
