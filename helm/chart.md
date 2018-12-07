# 创建自己的chart


我们创建一个名为mychart的chart，看一看chart的文件结构。

```
$ helm create mongodb
$ tree mongodb
mongodb
├── Chart.yaml #Chart本身的版本和配置信息
├── charts #依赖的chart
├── templates #配置模板目录
│   ├── NOTES.txt #helm提示信息
│   ├── _helpers.tpl #用于修改kubernetes objcet配置的模板
│   ├── deployment.yaml #kubernetes Deployment object
│   └── service.yaml #kubernetes Serivce
└── values.yaml #kubernetes object configuration

2 directories, 6 files
```

## 检查配置和模板是否有效
使用helm install --dry-run --debug <chart_dir>命令来验证chart配置。该输出中包含了模板的变量配置与最终渲染的yaml文件。

```
$ helm install --dry-run --debug mychart
```

## 部署到kubernetes
在mychart目录下执行下面的命令将nginx部署到kubernetes集群上。

```
helm install .
```


## 查看部署的relaese
```
$ helm list
NAME            REVISION    UPDATED                     STATUS      CHART            NAMESPACE
eating-hound    1           Wed Oct 25 14:58:15 2017    DEPLOYED    mychart-0.1.0    default
```
## 管理 chart
```
# 创建一个新的 chart
helm create hello-chart

# validate chart
helm lint

# 打包 chart 到 tgz
helm package hello-chart

```
## 删除部署的release

```
$ helm delete eating-hound
release "eating-hound" deleted
# 强制删除
helm del --purge my-release
```
## 打包分享

```
helm package .

我们可以修改Chart.yaml中的helm chart配置信息，然后使用下列命令将chart打包成一个压缩文件。
打包出mychart-0.1.0.tgz文件。

helm upgrade --install -f values.yaml --namespace dev springboot-demo  ./
```
## 依赖
我们可以在requirement.yaml中定义应用所依赖的chart，例如定义对mariadb的依赖：
```
dependencies:
- name: mariadb
  version: 0.6.0
  repository: https://kubernetes-charts.storage.googleapis.com

```
使用helm lint .命令可以检查依赖和模板配置是否正确。你也可以通过运行`helm dependency update` ，它会使用你的依赖关系文件将所有指定的chart下载到你的charts/目录中

## 安装源

使用第三方chat库 添加fabric8库

```
$helm repo add fabric8 https://fabric8.io/helm
```
