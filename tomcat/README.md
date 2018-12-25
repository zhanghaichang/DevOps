# Tomcat 性能调优

https://tomcat.apache.org/tomcat-8.0-doc/config/http.html

### Jmx JVM

先修改Tomcat的启动脚本，windows下为bin/catalina.bat（linux下为catalina.sh），添加以下内容:
```
set JMX_REMOTE_CONFIG=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.rmi.port=8999 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false  
set CATALINA_OPTS=%CATALINA_OPTS% %JMX_REMOTE_CONFIG% 
```

linux为
```
JAVA_OPTS=-Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.port=8999，是jmxremote使用的端口号，可修改。
-Dcom.sun.management.jmxremote.authenticate=false，表示不需要鉴权，主机+端口号即可监控。
```

## 容器特别篇

###  tomcat  Jdk8 jvm 
JVM垃圾回收的内存数是根据cpu核数推断的，而运行在容器中的JVM看到的是所有核。比如，宿主机有64核，允许容器使用2核，此时如果不指定线程数的话，JVM会启动64个线程来做垃圾回收。最终导致垃圾回收缓慢甚至失败。所以，如果应用运行在容器中时最好指定下垃圾回收的线程数。

以下两个参数最好等于CPU核数（之所以设置两个，是因为不指定gc算法时，JVM是根据及其情况自动选择的。）

```
CATALINA_OPTS "-Xms1g -Xmx1g -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2"

```
#### 如何确定自己的应用能使用多少内存
JDK8

去掉 `-Xms2g -Xmx2g`参数，增加`-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap`。然后修改values.yaml中的limit为16G，request为4G。给应用与实际场景类似的压力，然后监控看JVM的堆内存使用情况。然后根据监测结果来计算堆大小和非堆内存的大小。

下面说说为什么这样做。

`-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap`意思是让JVM根据Docker容器的限制自动配置堆大小。JVM会设置MaxHeapSize为limit/4。所以只要修改limit值为16，那么JVM的堆最大值就会被设置为4G。对于大多数应用4G的堆已经足够了，如果发现不够，可以加大limit继续测试。 request也设置为limit/4可以保证容器能申请足够的的内存给JVM。


### tomcat线程的设置：

初始产生1000线程数最大支持2000线程

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
<Executor name="tomcatThreadPool" 
          namePrefix="catalina-exec-" 
          maxThreads="500" minSpareThreads="100" 
          prestarminSpareThreads="true" maxQueueSize="100" />

```
参数解释：

* maxThreads：最大并发数，默认值200，一般建议在500~800，根据硬件设施和业务来判断。
* minSpareThreads：Tomcat初始化时创建的线程数，默认为25
* prestarminSpareThreads：在Tomcat初始化的时候就初始化minSpareThreads的参数值，如果不等于true，minSpareThreads的值就没啥效果了
* maxQueueSize：最大的等待队列数，超过则拒绝请求
 
### 修改连接参数
```xml
<Connector exexutor="tomcatThreadPool" port="8080" 
           protocol="prg.apache.coyote.http11.http11Nio2Protocol"connectionTimeout="20000" 
           maxConnections="10000"   redirectPort="8443" enableLookups="false"
           acceptCount="100" maxPostSize="10485760" compression="on"
           disableUploadTimeout="true" compressionMinSize="2048" acceptorThreadCount="2"
           compressableMimeType="text/html,text/xml,text/plain,text/css,text/javascript,application/javascript" YRIEncoding="utf-8" />
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
