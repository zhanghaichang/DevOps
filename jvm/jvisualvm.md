## jvisualvm jvm监控


为了监控服务器和服务器中JAVA进程，我们需要开启JMX，可以在JAVA进程启动的时候，添加如下几个参数：

```
JMX_OPTS="-Dcom.sun.management.jmxremote.port=7969 
-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false 
-Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=xx.xx.xx.xx"

## 启动
nohup java ${JMX_OPTS} -jar xxxxx.jar

```
## 开启JMX监控
```shell
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.port=12345
-Dcom.sun.management.jmxremote.rmi.port=12345
-Dcom.sun.management.jmxremote.ssl=false
-Dcom.sun.management.jmxremote.authenticate=false
-Djava.rmi.server.hostname=139.196.107.149
```

* Djava.rmi.server.hostname填写JAVA进程所在服务器的IP地址，

* -Dcom.sun.management.jmxremote.port=7969是指定JMX监控端口的，这里是7969。

重新启动进程后，打开本地的(我用的是Window10)jvisualvm，添加JMX配置。配置成功后，可以点击线程那个tab，因为我们要做线程dump，观察线程的执行情况。
