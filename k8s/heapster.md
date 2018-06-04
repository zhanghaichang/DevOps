### heapster插件部署

下面安装Heapster为集群添加使用统计和监控功能，为Dashboard添加仪表盘。 使用InfluxDB做为Heapster的后端存储，开始部署：

```
mkdir -p ~/k8s/heapster
cd ~/k8s/heapster
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml

kubectl create -f ./
```
