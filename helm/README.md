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
