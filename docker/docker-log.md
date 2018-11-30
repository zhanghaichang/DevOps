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
# 定时清理log日志


```
#!/bin/sh

echo "==================== start clean docker containers logs =========================="

logs=$(find /var/lib/docker/containers/ -name *-json.log)

for log in $logs

do

echo "clean logs : $log"

cat /dev/null > $log

done

echo "==================== end clean docker containers logs  =========================="

```
