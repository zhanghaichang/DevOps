# cAdvisor 监控
> cAdvisor是google开发的容器监控工具

1.在host上运行cadvisor容器

```shell
docker run \
--volume=/:/rootfs:ro \
--volume=/var/run:/var/run:rw \
--volume=/sys:/sys:ro \
--volume=/var/lib/docker/:/var/lib/docker:ro \
--publish=8080:8080 \
--detach=true \
--name=cadvisor \
--net=host \
google/cadvisor:latest
 ```
 注意，这里我们使用了 --net=host，这样 Prometheus Server 可以直接与 cAdvisor 通信。
 
 没有找这个文件, 这是一个bug,在系统中,是cpu,cpuacct

可以去文件的目录下查看:

ll -d /sys/fs/cgroup/

解决方法:

使用 软连接

sudo mount -o remount,rw '/sys/fs/cgroup'

sudo  ln -s /sys/fs/cgroup/cpu,cpuacct /sys/fs/cgroup/cpuacct,cpu

第一条命令是设置cgroup 为可读写文件, 不然的话会报:只读文件系统

第二句是建立软连接

这样就可以启动了.

 
 2.通过web访问  http：//【host_ip】:8080访问cadvisor
 
 
 
 
# Node Exporter 来收集硬件信息

所有节点运行以下命令安装Node Exporter 容器
```
docker run -d -p 9100:9100 \
  -v "/proc:/host/proc" \
  -v "/sys:/host/sys" \
  -v "/:/rootfs" \
  --net=host \
  prom/node-exporter \
  --path.procfs /host/proc \
  --path.sysfs /host/sys \
  --collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"
  ```
  注意，这里我们使用了 --net=host，这样 Prometheus Server 可以直接与 Node Exporter 通信
  
  2. Node Exporter 启动后，将通过 9100 提供 host 的监控数据。在浏览器中通过 http://192.168.131:9100/metrics 测试一下。
  
  
#  运行以下命令安装普罗米修斯服务
```shell
docker run -d -p 9090:9090 \
  -v /root/prometheus.yml:/etc/prometheus/prometheus.yml \
  --name prometheus \
  --net=host \
  prom/prometheus
```

# 8. 在DockerMachine上运行Grafana

```sehll
docker run -d -i -p 3000:3000 \
-e "GF_SERVER_ROOT_URL=http://grafana.server.name" \
-e "GF_SECURITY_ADMIN_PASSWORD=secret" \
--net=host \
grafana/grafana
```
注意，这里我们使用了 --net=host，这样 Grafana 可以直接与 Prometheus Server 通信。

-e "GF_SECURITY_ADMIN_PASSWORD=secret 指定了 Grafana admin用户密码 secret。
