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
