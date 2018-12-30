# istio install rancher 2.0



在你的命名空间里添加一个istio-injected标签，Istio sidecar容器会自动注入你的节点，运行下方的kubectl命令（如上文所述，你可以从Rancher内部启动kubectl）。
```shell
> kubectl label namespace default istio-injection=enabled

namespace "default" labeled

> kubectl get namespace -L istio-injection

NAME            STATUS    AGE       ISTIO-INJECTION
cattle-system   Active    1h
bookinfo         Active    1h        enabled
istio-system    Active    37m
kube-public     Active    1h
kube-system     Active    1h
>

```
这一标签将使得Istio-Sidecar-Injector自动将Envoy容器注入您的应用程序节点。



## 部署Bookinfo示例应用

https://preliminary.istio.io/zh/docs/examples/bookinfo/
