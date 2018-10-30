# Tomcat 性能调优


###  连接数

server.xml

```xml
<Connector port="8080" protocol="HTTP/1.1" connectionTimeout="20000" maxThreads="2000" 
           acceptCount="1000" redirectPort="8443" />
```

### tomcat管理界面登录

tomcat-users.xml 

```xml
<tomcat-users>
  <!--<role rolename="tomcat"/>
  <role rolename="role1"/>
  <user username="both" password="tomcat" roles="tomcat,role1"/>
  <user username="role1" password="tomcat" roles="role1"/>-->
  <role rolename="manager-gui"/>
  <user username="tomcat" password="tomcat" roles="manager-gui"/>
</tomcat-users>
```

### tomcat管理界面远程登录

tomcat/webapps/manager/META-INF/context.xml

```
<Context antiResourceLocking="false" privileged="true" >
    <Valve className="org.apache.catalina.valves.RemoteAddrValve" 
    allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
</Context>

改为

<Context antiResourceLocking="false" privileged="true" >
    <!--<Valve className="org.apache.catalina.valves.RemoteAddrValve" 
    allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />-->
</Context>
```
