# Maven Tomcat depoly 

## 开启Tomcat远程部署设置

### 1.配置tomcat-users.xml

首先在Tomcat里配置deploy的用户(tomcat根目录/conf/tomcat-users.xml):

```xml
<role rolename="tomcat"/>
<role rolename="manager"/>
<role rolename="manager-gui"/>
<role rolename="manager-script" />
<role rolename="admin-gui"/>
<user username="admin" password="admin" roles="tomcat,manager,manager-script,admin-gui" />
<user username="tomcat" password="tomcat" roles="manager-gui" />
```
### 2.配置maven setting.xml

修改Maven的setting.xml（默认是C:\Users\用户名.m2\settings.xml)，在节点下添加

```xml
<server>
  <id>tomcat7</id>
  <username>admin</username>
  <password>admin</password>
</server>
```

### 3.配置pom.xml  

```
<plugin>
           <groupId>org.apache.tomcat.maven</groupId>
            <artifactId>tomcat7-maven-plugin</artifactId>
            <version>2.2</version>
            <configuration>
                <url>http://127.0.0.1:8080/manager/text</url>
                <server>tomcat7</server>
                <path>/ROOT</path>
                <charset>utf8</charset>
                <update>true</update>
            </configuration>
</plugin>
```
pom.xml 依赖
```
<!-- 添加相关依赖 -->   
   <dependency>
            <groupId>org.apache.tomcat</groupId>
            <artifactId>tomcat-servlet-api</artifactId>
            <version>8.5.4</version>
        </dependency>
```

### 4.修改ip访问权限

将 /apache-tomcat-8.5.4/webapps/manager/META-INF/context.xml中的，ip限制去掉

```
<Context antiResourceLocking="false" privileged="true" >
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="192\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
</Context>
```
### 5.执行部署命令

在项目根目录下执行

```
//第一次
mvn tomcat7:deploy
//之后
mvn tomcat7:redeploy


//这里我要求先重新打包,并跳过测试,再部署
//第一次
mvn package  -Pdevelop -Dmaven.skip.test=true tomcat7:deploy

//之后
mvn package  -Pdevelop -Dmaven.skip.test=true tomcat7:redeploy
```

注意事项：

1.需要将远程机器的tomcat先开启,这里是热部署

2.可以在本地先调试好，再到远程去执行
