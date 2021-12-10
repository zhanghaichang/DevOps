# Helm Chart安装

所有的pod,svc等都放到了default的namespace下


## apisix

```
$ helm repo add apisix https://charts.apiseven.com
$ helm repo update
$ helm install apisix apisix/apisix
```

## apisix-dashboard

```
$ helm install apisix-dashboard apisix/apisix-dashboard
```
## apisix-ingress-controller

```
$ helm install apisix-ingress-controller apisix/apisix-ingress-controller --namespace default
```