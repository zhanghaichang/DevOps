# Deployment

### 扩容：
```
kubectl scale deployment nginx-deployment --replicas 10
```

### 更新镜像：
```
kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1
```
### 回滚：
```
kubectl rollout undo deployment/nginx-deployment

kubectl rollout status命令查看Deployment是否完成。如果rollout成功完成，kubectl rollout status将返回一个0值的Exit Code。

kubectl rollout status deploy/nginx
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
