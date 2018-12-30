# token认证问题

### 安装dashboard

首先下载官网提供的dashboard.yaml
```
wget https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
```

修改yaml,添加NodePort

```
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  # 添加Service的type为NodePort
  type: NodePort
  ports:
    - port: 443
      targetPort: 8443
      # 添加映射到虚拟机的端口,k8s只支持30000以上的端口
      nodePort: 30001
  selector:
    k8s-app: kubernetes-dashboard
```

### 安装dashboard
```
kubectl create -f kubernetes-dashboard.yaml
```

获取token

这里有一个简单的命令

```
kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token
```
也可以自己手动查询：

```
# 输入下面命令查询kube-system命名空间下的所有secret
kubectl get secret -n kube-system

# 然后获取token。只要是type为service-account-token的secret的token都可以使用。
# 比如我们获取replicaset-controller-token-wsv4v的touken
kubectl -n kube-system describe replicaset-controller-token-wsv4v
```
访问dashboard

通过node节点的ip，加刚刚我们设置的nodePort就可以访问了。
```

认证有两种方式：

通过我们刚刚获取的token直接认证
通过Kubeconfig文件认证
只需要在kubeadm生成的admin.conf文件末尾加上刚刚获取的token就好了
```
- name: kubernetes-admin
  user:
    client-certificate-data: xxxxxxxx
    client-key-data: xxxxxx
    token: "在这里加上token"
```
https://<node-ip>:<node-port>
```
