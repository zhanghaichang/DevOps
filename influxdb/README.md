# influxdb

```shell
docker run -p 8086:8086  -v $PWD:/var/lib/influxdb influxdb
#admin ui
docker run -p 8086:8086 -p 8083:8083 \
    -e INFLUXDB_ADMIN_ENABLED=true \
    influxdb

```

```

#docker run -d -p 8083:8083 -p8086:8086 --expose 8090 --expose 8099 --name influxDbService influxdb
 
-d：容器在后台运行
 
-p：将容器内端口映射到宿主机端口，格式为 宿主机端口:容器内端口；8083是influxdb的web管理工具端口，8086是influxdb的HTTP API端口
 
--expose：可以让容器接受外部传入的数据
 
--name：容器名称  此处influxDbService 则是启动后的容器名
 
最后是镜像名称influxdb，镜像名可以通过docker images 查看； 通过tag 区分启镜像版本。
如把版本为 0.8.8 的镜像 influxdb 放在容器名为 influxDbService 中启动 则可以执行
 --name influxDbService influxdb：0.8.8  若不加tag则启动的是最新版本 latest

```
