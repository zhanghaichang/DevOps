# centos 7卸载 docker 


## 1首先搜索已经安装的docker 安装包 
```shell
[root@localhost ~]# yum list installed|grep docker 
```
或者使用该命令 
```shell
[root@localhost ~]# rpm -qa|grep docker 
docker.x86_64 2:1.12.6-16.el7.centos @extras 
docker-client.x86_64 2:1.12.6-16.el7.centos @extras 
docker-common.x86_64 2:1.12.6-16.el7.centos @extra
```
## 2 分别删除安装包 
```shell
[root@localhost ~]#yum –y remove docker.x86_64 
[root@localhost ~]#yum –y remove docker-client.x86_64 
[root@localhost ~]#yum –y remove docker-common.x86_64 
```
## 3 删除docker 镜像 
```shell
[root@localhost ~]# rm -rf /var/lib/docker 
```
## 4 再次check docker是否已经卸载成功 
```shell
[root@localhost ~]# rm -rf /var/lib/docker 
[root@localhost ~]# 
```
如果没有搜索到，那么表示已经卸载成功。


## 或者

```shell
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
```
