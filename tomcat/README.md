# Tomcat 性能调优

https://tomcat.apache.org/tomcat-8.0-doc/config/http.html

###  tomcat jvm

Linux 修改 /root/tomcat/bin/catalina.sh 文件，把下面信息添加到文件第一行。

Windows 和 Linux 有点不一样的地方在于，在 Linux 下，下面的的参数值是被引号包围的，而 Windows 不需要引号包围。

```shell
机子内存如果是 4G：
 
CATALINA_OPTS="-Dfile.encoding=UTF-8 -server -Xms2048m -Xmx2048m -Xmn1024m -XX:PermSize=256m
-XX:MaxPermSize=512m -XX:SurvivorRatio=10 -XX:MaxTenuringThreshold=15 -XX:NewRatio=2 -XX:+DisableExplicitGC"
 
机子内存如果是 8G：
 
CATALINA_OPTS="-Dfile.encoding=UTF-8 -server -Xms4096m -Xmx4096m 
-Xmn2048m -XX:PermSize=256m -XX:MaxPermSize=512m -XX:SurvivorRatio=10 -XX:MaxTenuringThreshold=15 -XX:NewRatio=2 -XX:+DisableExplicitGC"
 
机子内存如果是 16G：
 
CATALINA_OPTS="-Dfile.encoding=UTF-8 -server -Xms8192m -Xmx8192m 
-Xmn4096m -XX:PermSize=256m -XX:MaxPermSize=512m -XX:SurvivorRatio=10 -XX:MaxTenuringThreshold=15 -XX:NewRatio=2 -XX:+DisableExplicitGC"
 
机子内存如果是 32G：
 
CATALINA_OPTS="-Dfile.encoding=UTF-8 -server -Xms16384m -Xmx16384m 
-Xmn8192m -XX:PermSize=256m -XX:MaxPermSize=512m -XX:SurvivorRatio=10 -XX:MaxTenuringThreshold=15 -XX:NewRatio=2 -XX:+DisableExplicitGC"
 
如果是 8G 开发机
 
-Xms2048m -Xmx2048m -XX:NewSize=512m -XX:MaxNewSize=1024m -XX:PermSize=256m -XX:MaxPermSize=512m
 
如果是 16G 开发机
 
-Xms4096m -Xmx4096m -XX:NewSize=1024m -XX:MaxNewSize=2048m -XX:PermSize=256m -XX:MaxPermSize=512m

```

参数说明：

-Dfile.encoding：默认文件编码

-server：表示这是应用于服务器的配置，JVM 内部会有特殊处理的

-Xmx1024m：设置JVM最大可用内存为1024MB

-Xms1024m：设置JVM最小内存为1024m。此值可以设置与-Xmx相同，以避免每次垃圾回收完成后JVM重新分配内存。

-Xmn1024m：设置JVM新生代大小（JDK1.4之后版本）。一般-Xmn的大小是-Xms的1/2左右，不要设置的过大或过小，过大导致老年代变小，频繁Full GC，过小导致minor GC频繁。如果不设置-Xmn，可以采用-XX:NewRatio=2来设置，也是一样的效果

-XX:NewSize：设置新生代大小

-XX:MaxNewSize：设置最大的新生代大小

-XX:PermSize：设置永久代大小

-XX:MaxPermSize：设置最大永久代大小

-XX:NewRatio=4：设置年轻代（包括 Eden 和两个 Survivor 区）与终身代的比值（除去永久代）。设置为 4，则年轻代与终身代所占比值为 1：4，年轻代占整个堆栈的 1/5

-XX:MaxTenuringThreshold=10：设置垃圾最大年龄，默认为：15。

如果设置为0 的话，则年轻代对象不经过 Survivor 区，直接进入年老代。

对于年老代比较多的应用，可以提高效率。如果将此值设置为一个较大值，则年轻代对象会在 Survivor 区进行多次复制，这样可以增加对象再年轻代的存活时间，增加在年轻代即被回收的概论。

需要注意的是，设置了 -XX:MaxTenuringThreshold，并不代表着，对象一定在年轻代存活15次才被晋升进入老年代，它只是一个最大值，事实上，存在一个动态计算机制，计算每次晋入老年代的阈值，取阈值和MaxTenuringThreshold中较小的一个为准。

-XX:+DisableExplicitGC：这个将会忽略手动调用 GC 的代码使得 System.gc() 的调用就会变成一个空调用，完全不会触发任何 GC
 etails/82908289 

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
