# Deployment

### 扩容：
```
kubectl scale deployment nginx-deployment --replicas 10
```

### 更新镜像：
```
kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1

更新使用的资源

kubectl set resources deployment nginx -c=nginx --limits=cpu=200m,memory=512Mi
```
### 回滚：
```
kubectl rollout undo deployment/nginx-deployment 

也可以使用 --revision参数指定某个历史版本：

kubectl rollout undo deployment/nginx-deployment --to-revision=2

kubectl rollout status命令查看Deployment是否完成。如果rollout成功完成，kubectl rollout status将返回一个0值的Exit Code。

kubectl rollout status deploy/nginx
```
### 回滚历史：
```
kubectl rollout history deployment/my-nginx
```

# ConfigMap

### 从key-value字符串创建ConfigMap

```
$ kubectl create configmap special-config --from-literal=special.how=very
configmap "special-config" created
```
### 从env文件创建
```
$ echo -e "a=b\nc=d" | tee config.env
a=b
c=d
$ kubectl create configmap special-config --from-env-file=config.env
configmap "special-config" created
$ kubectl get configmap special-config -o go-template='{{.data}}'
map[a:b c:d]
```
### 从目录创建
```
$ mkdir config
$ echo a>config/a
$ echo b>config/b
$ kubectl create configmap special-config --from-file=config/
configmap "special-config" created
$ kubectl get configmap special-config -o go-template='{{.data}}'
map[a:a
 b:b
]
```
