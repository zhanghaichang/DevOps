# Jvm参数如何配置

如果Dockerfile里预留了`JVM_OPTS`环境变量，可以在`values.yaml`中通过`JVM_OPTS`来配置。当然也可以在Dockerfile中写配置

**提醒：** 改了内存，别忘了改`values.yaml`中的resource配置。如果堆内存准备给2G，那么建议resource里的request给2.5G，limit给4G。`values.yaml`中的limit最好是request的2-4倍。

## JDK 8

小于8G内存时，默认参数就是经过专业团队测试的适应大多数场景的参数，无需调整。加上内存和GC日志参数即可，**大多数应用用这个配置已经足够了**，如：
```
-Xms2g -Xmx2g -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps
```

如果使用CMS垃圾回收器，希望尽早回收垃圾对象，比如希望old使用率达到75%就出发垃圾回收，它的默认值是80%，等于CMSTriggerRatio
```
-XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly
```

JVM启动时,虽然为JVM指定了内存大小,但是这些内存操作系统并没有真正的分配给JVM,而是等JVM访问这些内存的时候才分配。如果希望系统立即分配内存可以加如下配置。
```
-XX:+AlwaysPreTouch
```

## JDK 7

能用8就不要用7了。JDK7中还有permsize要手工配置。它是用来存放class信息的。8以后已经不需要配置了。对于jar包使用较多的应用，需要增大permsize，如下
```
-XX:PermSize=256m -XX:MaxPermSize=512m
```
内存分配比例一般情况下**不需要调整**，NewRatio表示young/old，默认是2，SurvivorRatio表示eden/survivor，默认是8，注意，survivor一般有两个，也就是说eden占young的8/10。如果要调整，用如下参数
```
 -XX:NewRatio=2 -XX:SurvivorRatio=6
```

# 容器特别篇

JVM垃圾回收的内存数是根据cpu核数推断的，而运行在容器中的JVM看到的是所有核。比如，宿主机有64核，允许容器使用2核，此时如果不指定线程数的话，JVM会启动64个线程来做垃圾回收。最终导致垃圾回收缓慢甚至失败。所以，如果应用运行在容器中时最好指定下垃圾回收的线程数。

以下两个参数最好等于CPU核数（之所以设置两个，是因为不指定gc算法时，JVM是根据及其情况自动选择的，按上面的写法会选择ParallelGC）

```
 -XX:ConcGCThreads=threads
           Sets the number of threads used for concurrent GC. The default value depends on the number of CPUs available to the JVM.
 -XX:ParallelGCThreads=threads
           Sets the number of threads used for parallel garbage collection in the young and old generations. The default value depends on
           the number of CPUs available to the JVM.
```

综上所述，假设应用需要2G内存，CPU最大使用2核，那么建议的JVM配置如下
```
-Xms2g -Xmx2g -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2
```

## 如何确定自己的应用能使用多少内存

### JDK8

去掉 `-Xms2g -Xmx2g`参数，增加`-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap`。然后修改`values.yaml`中的limit为16G，request为4G。给应用与实际场景类似的压力，然后监控看JVM的堆内存使用情况。然后根据监测结果来计算堆大小和非堆内存的大小。

下面说说为什么这样做。

`-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap`意思是让JVM根据Docker容器的限制自动配置堆大小。JVM会设置MaxHeapSize为limit/4。所以只要修改limit值为16，那么JVM的堆最大值就会被设置为4G。对于大多数应用4G的堆已经足够了，如果发现不够，可以加大limit继续测试。 request也设置为limit/4可以保证容器能申请足够的的内存给JVM。

# 资料

在线gc分析工具 http://gceasy.io
