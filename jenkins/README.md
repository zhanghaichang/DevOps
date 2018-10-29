# Jenkins 安装教程

## docker install 

```
docker pull jenkins/jenkins:lts
```

## 创建目录赋权限 

```
mkdir /home/jenkins 

chown -R 1000:1000 jenkins/ 
```
##  centos library 安装

```
yum install libltdl.so.7

##
which libltdl.so.7

/usr/lib64/libltdl.so.7

```

在 Jenkins 镜像中使用这个 library 的位置是 /usr/lib/x86_64-linux-gnu/libltdl.so.7，通过 -v 映射即可。


## 官方镜像 docker run

```
docker run -d -p 8080:8080 -p 50000:50000  -u root --name jenkins --restart=always \
-v /root/home/jenkins/:/var/jenkins_home \
-v $(which docker):/usr/bin/docker \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/lib/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7 \
-d jenkins/jenkins:lts
```
## docker run 

```
docker run -d -p 8080:8080 -p 50000:50000  --name jenkins --restart=always \
-v /root/home/jenkins/:/var/jenkins_home \
-v $(which docker):/usr/bin/docker \
-v /var/run/docker.sock:/var/run/docker.sock \
-d zhanghaichang/jenkins:latest
```

### 获取初始密码

```
cd /home/jenkins/secrets 

tail initialAdminPassword 
```

## 添加Jenkins用户到Docker用户组

```
sudo usermod -a -G docker jenkins

```

#### 永久关闭,可以修改配置文件/etc/selinux/config

```
[root@localhost ~]# cat /etc/selinux/config   

# This file controls the state of SELinux on the system.  
# SELINUX= can take one of these three values:  
#     enforcing - SELinux security policy is enforced.  
#     permissive - SELinux prints warnings instead of enforcing.  
#     disabled - No SELinux policy is loaded.  
#SELINUX=enforcing  
SELINUX=disabled  
# SELINUXTYPE= can take one of three two values:  
#     targeted - Targeted processes are protected,  
#     minimum - Modification of targeted policy. Only selected processes are protected.   
#     mls - Multi Level Security protection.  
SELINUXTYPE=targeted

## 刷新

[root@rdo ~]# setenforce 0

[root@rdo ~]# sestatus  
SELinux status:                 disabled
```


### 可能遇到的问题：docker run的时候出现 
```
/usr/bin/docker-current: Error response from daemon: error creating overlay mount to /var/lib/docker/overlay2/
```

解决办法： 

这个是因为用的overlay2文件系统，而系统默认只能识别overlay文件系统

所以我们就要更新文件系统了 
```
systemctl stop docker //停掉docker服务 
rm -rf /var/lib/docker //注意会清掉docker images的镜像 
vi /etc/sysconfig/docker-storage //将文件里的overlay2改成overlay即可 
DOCKER_STORAGE_OPTIONS=”–storage-driver overlay ” 
```
然后启动docker即可：

```systemctl start docker
```
