# Open JDK 安装

* 系统版本：CentOS7.6

* 安装版本：java-1.8.0-openjdk


1. 查看可安装JDK版本

```shell
yum search java | grep -i --color JDK

```
使用指令列出所有可安装版本号，并选中想要安装版本号，执行后续步骤。

 2. 安装指定版本JDK

```shell
yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel
```

安装期间会有确认提示，输入y继续即可。看到Complete! 即安装完成，默认安装至/usr/lib/jvm下。

3. 查看安装情况

```
[root@vm04centos ~]# java -version
openjdk version "1.8.0_232"
OpenJDK Runtime Environment (build 1.8.0_232-b09)
OpenJDK 64-Bit Server VM (build 25.232-b09, mixed mode)
// 查看安装目录，l为链接，d为文件夹
[root@vm04centos ~]# cd /usr/lib/jvm
[root@vm04centos jvm]# ll
total 4
lrwxrwxrwx 1 root root   26 Jan  2 10:05 java -> /etc/alternatives/java_sdk
lrwxrwxrwx 1 root root   32 Jan  2 10:05 java-1.8.0 -> /etc/alternatives/java_sdk_1.8.0
lrwxrwxrwx 1 root root   40 Jan  2 10:05 java-1.8.0-openjdk -> /etc/alternatives/java_sdk_1.8.0_openjdk
drwxr-xr-x 7 root root 4096 Jan  2 10:05 java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64
lrwxrwxrwx 1 root root   34 Jan  2 10:05 java-openjdk -> /etc/alternatives/java_sdk_openjdk
lrwxrwxrwx 1 root root   21 Jan  2 10:05 jre -> /etc/alternatives/jre
lrwxrwxrwx 1 root root   27 Jan  2 10:05 jre-1.8.0 -> /etc/alternatives/jre_1.8.0
lrwxrwxrwx 1 root root   35 Jan  2 10:05 jre-1.8.0-openjdk -> /etc/alternatives/jre_1.8.0_openjdk
lrwxrwxrwx 1 root root   51 Jan  2 10:05 jre-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64 -> java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64/jre
lrwxrwxrwx 1 root root   29 Jan  2 10:05 jre-openjdk -> /etc/alternatives/jre_openjdk
```

4. 配置环境变量

```
vim /etc/profile
```

在profile末尾追加环境变量JAVA_HOME、CLASSPATH、PATH

```shell
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/jre/lib/dt.jar:$JAVA_HOME/lib/tool.jar
export PATH=$PATH:$JAVA_HOME/bin
```

* rt.jar:Java基础库，即Java doc里面看到的所有类。
* dt.jar:运行环境类库，主要为swing包，使用swing时可以加上。
* tool.jar是系统编译（javac）时要使用的一个类库。

※CLASSPATH加载类库各版本并不相同，具体可视情况而定，以上配置仅供参考。

5. 使配置生效:source /etc/profile

```shell
[root@vm04centos jvm]# source /etc/profile
[root@vm04centos jvm]# java -version
openjdk version "1.8.0_232"
OpenJDK Runtime Environment (build 1.8.0_232-b09)
OpenJDK 64-Bit Server VM (build 25.232-b09, mixed mode)
```

