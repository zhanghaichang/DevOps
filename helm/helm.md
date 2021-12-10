## 1 helm安装


https://github.com/helm/helm/releases/tag/v3.1.2 下载地址

1 下载3.0的版本，然后解压，把helm命令移动到/usr/local/bin目录下面

2 查看helm版本

```
helm version
```

## 2 配置下载源

```
helm repo add stable https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
```

## 3 查看下载源

```
[root@k8s-master01 helm-v3]# helm repo list
NAME  	URL                                                   
stable	https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
```

## 4 查询要安装的pod

helm search repo weave #后面跟你要查找的软件名字

```
helm search repo weave
NAME              	CHART VERSION	APP VERSION	DESCRIPTION                                       
stable/weave-cloud	0.1.2        	           	Weave Cloud is a add-on to Kubernetes which pro...
stable/weave-scope	0.9.2        	1.6.5      	A Helm chart for the Weave Scope cluster visual...
```
