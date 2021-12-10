# Helm Chart安装

所有的pod,svc等都放到了default的namespace下


## apisix

```
helm repo add apisix https://charts.apiseven.com
helm repo update
helm install apisix apisix/apisix --set admin.allow.ipList="{0.0.0.0/0}"
```

## apisix-dashboard

```
helm install apisix-dashboard apisix/apisix-dashboard
```
## apisix-ingress-controller

```
helm install apisix-ingress-controller apisix/apisix-ingress-controller --namespace default --set config.kubernetes.ingressVersion=networking/v1beta1 --set config.apisix.base_url=http://apisix-admin:9180/apisix/admin
```

## 访问apisix-dashboard和验证安装

dashboard

```
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=apisix-dashboard,app.kubernetes.io/instance=apisix-dashboard" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
2. username: admin password:admin
3. 使用 port-forward 可以访问 dashboard
```

apisix-gateway

```
1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services apisix-gateway)
  export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
2. apisix-gateway 对外暴露的 `apisix` 的端口即代理的端口

```

## 实例代理 whoami

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: whoami
spec:
  selector:
    matchLabels:
      run: whoami
  replicas: 2
  template:
    metadata:
      labels:
        run: whoami
    spec:
      containers:
      - name: whoami
        image: containous/whoami
        ports:
        - containerPort: 80

```

## 部署whoami的svc

```yaml
apiVersion: v1
kind: Service
metadata:
  name: whoami
  labels:
    run: whoami
spec:
  ports:
  - port: 80
    protocol: TCP
  selector:
    run: whoami
```

## 配置路由代理-使用apisix的方式apisix-route.yml

```yaml
apiVersion: apisix.apache.org/v2beta1
kind: ApisixRoute
metadata:
  name: httpserver-route
spec:
  http:
  - name: rule1
    match:
      hosts:
      - local.whoami.org
      paths:
      - /whoami
    backend:
        serviceName: whoami
        servicePort: 80
```

## 配置路由代理-使用ingress的方式apisix-ingress.yml

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: httpserver-ingress
spec:
  # apisix-ingress-controller is only interested in Ingress
  # resources with the matched ingressClass name, in our case,
  # it's apisix.
  ingressClassName: apisix
  rules:
  - host: local.whoami.com
    http:
      paths:
        - path: /whoami
          pathType: Prefix
          backend:
            service:
              name: whoami
              port:
                number: 80
```

## 测试访问

whoami 修改路由的域名选项改成空
