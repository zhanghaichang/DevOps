# Tomcat 性能调优

https://tomcat.apache.org/tomcat-8.0-doc/config/http.html

tomcat内存的设置：1.4GBJVM+256MB的池

```shell
set JAVA_HOME=C:\JAVA\JDK15
set CATALINA_OPTS=-server -Xms 1400m -Xmx1400m -XX:PermSize=256m -XX:MaxPermSize=256m
```
tomcat线程的设置：初始产生1000线程数最大支持2000线程
```xml
<Connector port="80" maxHttpHeaderSize="8192"
               maxThreads="4000" minSpareThreads="1000" maxSpareThreads="2000"
               enableLookups="false" redirectPort="8443" acceptCount="2000"
               connectionTimeout="20000" disableUploadTimeout="true" />
```           
```xml
<Connector 
   executor="tomcatThreadPool"
   port="8080" 
   protocol="org.apache.coyote.http11.Http11Nio2Protocol" 
   connectionTimeout="20000" 
   maxConnections="10000" 
   redirectPort="8443" 
   enableLookups="false" 
   acceptCount="100" 
   maxPostSize="10485760" 
   compression="on" 
   disableUploadTimeout="true" 
   compressionMinSize="2048" 
   acceptorThreadCount="2" 
   compressableMimeType="text/html,text/xml,text/plain,text/css,text/javascript,application/javascript" 
   URIEncoding="utf-8"
/>
```
###  线程池配置  

server.xml

```xml
<Executor name="tomcatThreadPool" namePrefix="catalina-exec-" maxThreads="500" minSpareThreads="100" prestarminSpareThreads="true" maxQueueSize="100" />

```
参数解释：

* maxThreads：最大并发数，默认值200，一般建议在500~800，根据硬件设施和业务来判断。
* minSpareThreads：Tomcat初始化时创建的线程数，默认为25
* prestarminSpareThreads：在Tomcat初始化的时候就初始化minSpareThreads的参数值，如果不等于true，minSpareThreads的值就没啥效果了
* maxQueueSize：最大的等待队列数，超过则拒绝请求
 
### 修改连接参数
```xml
<Connector exexutor="tomcatThreadPool" port="8080" protocol="prg.apache.coyote.http11.http11Nio2Protocol"connectionTimeout="20000" maxConnections="10000"   redirectPort="8443" enableLookups="false" acceptCount="100" maxPostSize="10485760" compression="on" disableUploadTimeout="true" compressionMinSize="2048" acceptorThreadCount="2" compressableMimeType="text/html,text/xml,text/plain,text/css,text/javascript,application/javascript" YRIEncoding="utf-8" />
```
参数解释：

* protocol：Tomcat6、7设置为nio更好：org.apache.coyote.http11.http11NioProtocol，Tomcat8的nio为：org.apache.coyote.http11.http11Nio2Protocol
* enableLookups：禁用DNS查询
* acceptCount：指定当所有可用处理请求的线程数都被使用时，可以放入处理队列中的请求数，超过这个数的请求将不被吹，默认设置100
* maxPostSize：以FORM URL参数方式的POST提交方式，限制提交最大的大小，默认为2097152（2M），它使用的单位是字节。如果要禁用限制，则可用设置为-1.
* acceptorThreadCount：接受连接的线程数量，默认为1.一般这个值需要改动的时候是因为该服务器是一个多核CPU，如果是多核CPU一般配置为2.
 
从测试结果分析连接参数增加：acceptorThreadCount="4"（接受连接的线程数量，默认为1.一般这个值需要改动的时候是因为该服务器是一个多核CPU，如果是多核CPU一般配置为2.）  能够增加服务器每秒处理的请求数量；建议生产环境加上该参数。

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
