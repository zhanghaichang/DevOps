# 修改日志类型

```
vim /etc/sysconfig/docker
```
修改 
```
--log-driver=json-file
```
重启docker服务： 

```
service docker restart
```
