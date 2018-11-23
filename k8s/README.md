
# K8S 操作基本命令


**通过yaml文件创建：**

```shell
# （不建议使用，无法更新，必须先delete）
kubectl create -f xxx.yaml 

# （创建+更新，可以重复使用）
kubectl apply -f xxx.yaml 
```
 

**通过yaml文件删除：**
```shell
kubectl delete -f xxx.yaml
```
 

**查看kube-system namespace下面的pod/svc/deployment 等等（-o wide  选项可以查看存在哪个对应的节点）**
```shell
kubectl get pod/svc/deployment -n kube-system
```
  

**查看所有namespace下面的pod/svc/deployment等等**
```shell
kubectl get pod/svc/deployment --all-namcpaces 
```
 

**重启pod（无法删除对应的应用，因为存在deployment/rc之类的副本控制器，删除pod也会重新拉起来）**
```shell
kubectl get pod -n kube-system
```
 

**查看pod描述：**
```shell
kubectl describe pod XXX -n kube-system
```
 

**查看pod 日志 （如果pod有多个容器需要加-c 容器名）**
```shell
kubectl logs xxx -n kube-system  
```
 

**删除应用（先确定是由说明创建的，再删除对应的kind）：**
```shell
kubectl delete deployment xxx -n kube-system
```
**强制删除pod命令:**
 ```
 kubectl delete pods <pod> --grace-period=0 --force
```
**根据label删除：**
```shell
kubectl delete pod -l app=flannel -n kube-system
```
 

**扩容**
```shell
kubectl scale deployment spark-worker-deployment --replicas=8
```
 

**导出配置文件：**
```shell
 导出proxy
 kubectl get ds -n kube-system -l k8s-app=kube-proxy -o yaml>kube-proxy-ds.yaml
 导出kube-dns
 kubectl get deployment -n kube-system -l k8s-app=kube-dns -o yaml >kube-dns-dp.yaml
 kubectl get services -n kube-system -l k8s-app=kube-dns -o yaml >kube-dns-services.yaml
 导出所有 configmap
 kubectl get configmap -n kube-system -o wide -o yaml > configmap.yaml
```
 

**复杂操作命令：**

删除kube-system 下Evicted状态的所有pod：
```shell
kubectl get pods -n kube-system |grep Evicted| awk '{print $1}'|xargs kubectl delete pod  -n kube-system
```
 

# 以下为维护环境相关命令：

**重启kubelet服务**
```shell
systemctl daemon-reload
systemctl restart kubelet
```
 

**修改启动参数**
```shell
vim /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
```
 

**查看集群信息**
```shell
kubectl cluster-info
```
 

**查看各组件信息**
```shell
kubectl get componentstatuses
```
 

**查看kubelet进程启动参数**
```shell
ps -ef | grep kubelet
```
 

**查看日志:**
```shell
journalctl -u kubelet -f
```
 

**设为不可调度状态：**
```shell
kubectl cordon node1
```
 

**将pod赶到其他节点：**
```shell
kubectl drain node1
```
 
**解除不可调度状态**
```shell
kubectl uncordon node1
```
 

**污点master运行pod**

```shell
kubectl taint nodes master.k8s node-role.kubernetes.io/master-
```

**污点master不运行pod**
```shell
kubectl taint nodes master.k8s node-role.kubernetes.io/master=:NoSchedule
```
----
```
kubectl exec `kubectl get pods -l run=my-nginx  -o=name|cut -d "/" -f2` cat /tmp/log_level
```
