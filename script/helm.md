Helm安装
Helm CLINET安装
Helm Client安装过程如下：

下载 Helm 2.6.1：https://storage.googleapis.com/kubernetes-helm/helm-v2.6.1-linux-amd64.tar.gz
解包：tar -zxvf helm-v2.6.1-linux-amd64.tgz
helm二进制文件移到/usr/local/bin目录：
mv linux-amd64/helm /usr/local/bin/helm

Helm TILLER安装
Helm Tiller是Helm的server，Tiller有多种安装方式，比如本地安装或以pod形式部署到Kubernetes集群中。本文以pod安装为例，安装Tiller的最简单方式是helm init, 该命令会检查helm本地环境设置是否正确，helm init会连接kubectl默认连接的kubernetes集群（可以通过kubectl config view查看），一旦连接集群成功，tiller会被安装到kube-system namespace中。

执行
helm init --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.6.1 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
，该命令会在当前目录下创建helm文件夹即~/.helm，并且通过Kubernetes Deployment 部署tiller. 检查Tiller是否成功安装：

$ kubectl get po -n kube-system
NAME                             READY   STATUS   RESTARTS   AGE
tiller-deploy-1046433508-rj51m   1/1     Running  0          3m

##  创建本地chart仓库
创建chart仓库有多种方式，本文以创建一个本地仓库为例：

$ helm serve –address 0.0.0.0:8879 –repo-path ./charts




