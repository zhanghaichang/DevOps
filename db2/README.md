# Db2 安装

[dbeaver](https://dbeaver.io/download/)

db2_developer_c

```
docker pull store/ibmcorp/db2_developer_c:11.1.4.4-x86_64
```


```
docker run -h db2server_developer_c --name db2server --restart=always  --detach --privileged=true -p 50000:50000 -p 55000:55000  --env-file /data/db2/.env_list  -v /data/db2/data/:/database store/ibmcorp/db2_developer_c:11.1.4.4-x86_64
```


```
docker exec -ti d4fc021e52aa bash -c "su - ${DB2INSTANCE}"
```
