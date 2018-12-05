## maven 安装 版本要求maven3.2.3

### 软件下载

```
wget http://mirror.bit.edu.cn/apache/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz
```

### 安装

```
tar vxf apache-maven-3.2.3-bin.tar.gz

$ mv apache-maven-3.2.3 /usr/local/maven3
```

### 修改环境变量

```
在/etc/profile中添加以下几行

MAVEN_HOME=/usr/local/maven3

export MAVEN_HOME

export PATH=${PATH}:${MAVEN_HOME}/bin
```

记得执行source /etc/profile使环境变量生效。

### 验证

最后运行mvn -v验证maven是否安装成功，如果安装成功会打印如下内容
```
Apache Maven 3.2.3 (33f8c3e1027c3ddde99d3cdebad2656a31e8fdf4; 2014-08-12T04:58:10+08:00)

Maven home: /usr/local/maven3

Java version: 1.7.0_65, vendor: Oracle Corporation

Java home: /usr/lib/jvm/java-7-openjdk-amd64/jre

Default locale: en_US, platform encoding: UTF-8

OS name: "linux", version: "3.13.0-35-generic", arch: "amd64", family: "unix"
```

### 创建maven项目

> mvn archetype:create -DgroupId=helloworld -DartifactId=helloworld

### maven 阿里云的setting.xml

```xml
<mirrors>
        <mirror>
            <id>nexus-aliyun</id>
            <mirrorOf>central</mirrorOf>
            <name>Nexus aliyun</name>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        </mirror>
</mirrors>
```
