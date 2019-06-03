# influxdb


### 1. 简介：

Influxdb是一个开源分布式时序、事件和指标数据库。使用Go 语言编写，无需外部依赖。其设计目标是实现分布式和水平伸缩扩展。本文主要介绍在Docker环境下Influxdb的使用。

InfluxDB有三大特性：

* 1 Time Series （时间序列）：你可以使用与时间有关的相关函数（如最大，最小，求和等）
* 2 Metrics（度量）：你可以实时对大量数据进行计算
* 3 Eevents（事件）：它支持任意的事件数据

**特点**

* 1 schemaless(无结构)，可以是任意数量的列
* 2 Scalable
* 3 min, max, sum, count, mean,median 一系列函数，方便统计
* 4 Native HTTP API, 内置http支持，使用http读写
* 5 Powerful Query Language 类似sql
* 6 Built-in Explorer 自带管理工具


```shell
docker run -d -p 8083:8083 -p 8086:8086 -e ADMIN_USER="root" -e INFLUXDB_INIT_PWD="somepassword" -e PRE_CREATE_DB="db1;db2;db3" tutum/influxdb:latest

```

启动influxdb后，influxdb会启动一个内部的HTTP server管理工具，用户可以通过接入该web服务器来操作influxdb。当然，也可以通过CLI即命令行的方式访问influxdb。打开浏览器，输入http://Host_IP:8083，访问管理工具的主页：


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

### 相关配置文件

```
/etc/influxdb/influxdb.conf 默认的配置文件
/var/log/influxdb/influxd.log 日志文件
/var/lib/influxdb/data 数据文件
/usr/lib/influxdb/scripts 初始化脚本文件夹
/usr/bin/influx 启动数据
 ```
