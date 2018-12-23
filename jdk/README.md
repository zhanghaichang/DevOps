# JDK install shell

```
curl -L https://raw.githubusercontent.com/zhanghaichang/DevOps/master/jdk/jdk-install.sh | sh
```

# 卸载Open JDK


先查看 rpm -qa | grep java

显示如下信息：

    java-1.4.2-gcj-compat-1.4.2.0-40jpp.115
    java-1.6.0-openjdk-1.6.0.0-1.7.b09.el5

卸载：

    rpm -e --nodeps java-1.4.2-gcj-compat-1.4.2.0-40jpp.115
    rpm -e --nodeps java-1.6.0-openjdk-1.6.0.0-1.7.b09.el5

还有一些其他的命令

    rpm -qa | grep gcj

    rpm -qa | grep jdk

如果出现找不到openjdk source的话，那么还可以这样卸载

    yum -y remove java java-1.4.2-gcj-compat-1.4.2.0-40jpp.115
    yum -y remove java java-1.6.0-openjdk-1.6.0.0-1.7.b09.el5
