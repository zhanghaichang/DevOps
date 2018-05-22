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
## Horizontal Pod Autoscaling

### Kubernetes Metrics Server
```
git clone https://github.com/kubernetes-incubator/metrics-server.git

# Kubernetes > 1.8
$ kubectl create -f deploy/1.8+/
```
### HPA

```
# 创建pod和service
$ kubectl run php-apache --image=gcr.io/google_containers/hpa-example --requests=cpu=200m --expose --port=80
service "php-apache" created
deployment "php-apache" created

# 创建autoscaler
$ kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
deployment "php-apache" autoscaled
$ kubectl get hpa
NAME         REFERENCE                     TARGET    CURRENT   MINPODS   MAXPODS   AGE
php-apache   Deployment/php-apache/scale   50%       0%        1         10        18s

# 增加负载
$ kubectl run -i --tty load-generator --image=busybox /bin/sh
Hit enter for command prompt
$ while true; do wget -q -O- http://php-apache.default.svc.cluster.local; done

# 过一会就可以看到负载升高了
$ kubectl get hpa
NAME         REFERENCE                     TARGET    CURRENT   MINPODS   MAXPODS   AGE
php-apache   Deployment/php-apache/scale   50%       305%      1         10        3m

# autoscaler将这个deployment扩展为7个pod
$ kubectl get deployment php-apache
NAME         DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
php-apache   7         7         7            7           19m

# 删除刚才创建的负载增加pod后会发现负载降低，并且pod数量也自动降回1个
$ kubectl get hpa
NAME         REFERENCE                     TARGET    CURRENT   MINPODS   MAXPODS   AGE
php-apache   Deployment/php-apache/scale   50%       0%        1         10        11m

$ kubectl get deployment php-apache
NAME         DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
php-apache   1         1         1            1           27m
```
