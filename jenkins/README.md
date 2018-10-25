# Jenkins 安装教程

## docker install 

```
docker pull jenkins/jenkins:lts
```

## docker run

```
docker run -p 8080:8080 -p 50000:50000 -u 0 -v /root/home/jenkins/:/var/jenkins_home -d jenkins/jenkins:lts
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

[root@rdo ~]# sestatus  
SELinux status:                 disabled
```
