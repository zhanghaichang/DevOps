# 使用Helm管理kubernetes应用

Helm是一个kubernetes应用的包管理工具，用来管理charts——预先配置好的安装包资源，有点类似于Ubuntu的APT和CentOS中的yum。


Helm chart是用来封装kubernetes原生应用程序的yaml文件，可以在你部署应用的时候自定义应用程序的一些metadata，便与应用程序的分发。



Helm和charts的主要作用：

* 应用程序封装
* 版本管理
* 依赖检查
* 便于应用程序分发

## Helm 安装

```
$ curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```

#### 创建tiller的serviceaccount和clusterrolebinding

```
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
```
#### 安装helm服务端tiller

```
helm init -i jimmysong/kubernetes-helm-tiller:v2.8.1
```
(目前最新版v2.8.2，可以使用阿里云镜像，如： helm init --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.8.2 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts）

我们使用-i指定自己的镜像，因为官方的镜像因为某些原因无法拉取，官方镜像地址是：gcr.io/kubernetes-helm/tiller:v2.8.1，我在DockerHub上放了一个备份jimmysong/kubernetes-helm-tiller:v2.8.1，该镜像的版本与helm客户端的版本相同，使用helm version可查看helm客户端版本。

#### 为应用程序设置serviceAccount：

```
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```
#### 检查是否安装成功：
```
$ helm version
Client: &version.Version{SemVer:"v2.3.1", GitCommit:"32562a3040bb5ca690339b9840b6f60f8ce25da4", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.3.1", GitCommit:"32562a3040bb5ca690339b9840b6f60f8ce25da4", GitTreeState:"clean"}
```
