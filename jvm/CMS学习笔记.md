### 引子

带着问题去学习一个东西，才会有目标感，我先把一直以来自己对CMS的一些疑惑罗列了下，希望这篇学习笔记能解决掉这些疑惑，希望也能对你有所帮助。

1.  CMS出现的初衷、背景和目的？
2.  CMS的适用场景？
3.  CMS的trade-off是什么?优势、劣势和代价
4.  CMS会回收哪个区域的对象？
5.  CMS的GC Roots包括那些对象？
6.  CMS的过程？
7.  CMS和Full gc是不是一回事？
8.  CMS何时触发？
9.  CMS的日志如何分析？
10.  CMS的调优如何做？
11.  CMS扫描那些对象？
12.  CMS和CMS collector的区别？
13.  CMS的推荐参数设置？
14.  为什么ParNew可以和CMS配合使用，而Parallel Scanvenge不可以？

### 一、基础知识

1.  CMS收集器：Mostly-Concurrent收集器，也称并发标记清除收集器（Concurrent Mark-Sweep GC，CMS收集器），它管理新生代的方式与Parallel收集器和Serial收集器相同，而在老年代则是尽可能得并发执行，每个垃圾收集器周期只有2次短停顿。
2.  我之前对CMS的理解，以为它是针对老年代的收集器。今天查阅了《Java性能优化权威指南》和《Java性能权威指南》两本书，确认之前的理解是错误的。
3.  CMS的初衷和目的：为了消除Throught收集器和Serial收集器在Full GC周期中的长时间停顿。
4.  CMS的适用场景：如果你的应用需要更快的响应，不希望有长时间的停顿，同时你的CPU资源也比较丰富，就适合适用CMS收集器。

### 二、CMS的过程

#### CMS的正常过程

这里我们首先看下CMS并发收集周期正常完成的几个状态。

1.  （STW）初始标记：这个阶段是标记从GcRoots直接可达的老年代对象、新生代引用的老年代对象，就是下图中灰色的点。这个过程是单线程的（JDK7之前单线程，JDK8之后并行，可以通过参数_CMSParallelInitialMarkEnabled_调整）。
    
    ![](//upload-images.jianshu.io/upload_images/44770-0445de4be3f6fdb2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/730/format/webp)
    
    初始标记标记的对象
    
2.  并发标记：由上一个阶段标记过的对象，开始tracing过程，标记所有可达的对象，这个阶段垃圾回收线程和应用线程同时运行，如上图中的灰色的点。在并发标记过程中，应用线程还在跑，因此会导致有些对象会从新生代晋升到老年代、有些老年代的对象引用会被改变、有些对象会直接分配到老年代，这些受到影响的老年代对象所在的card会被标记为dirty，用于重新标记阶段扫描。这个阶段过程中，老年代对象的card被标记为dirty的可能原因，就是下图中绿色的线：
    
    并发标记过程中受到影响的对象
    
3.  预清理：预清理，也是用于标记老年代存活的对象，目的是为了让重新标记阶段的STW尽可能短。这个阶段的目标是在并发标记阶段被应用线程影响到的老年代对象，包括：（1）老年代中card为dirty的对象；（2）幸存区(from和to)中引用的老年代对象。因此，这个阶段也需要扫描新生代+老年代。【PS：会不会扫描Eden区的对象，我看源代码猜测是没有，还需要继续求证】
    
    预清理中扫描from和to区
    
4.  可中断的预清理：这个阶段的目标跟“预清理”阶段相同，也是为了减轻重新标记阶段的工作量。可中断预清理的价值：在进入重新标记阶段之前尽量等到一个Minor GC，尽量缩短重新标记阶段的停顿时间。另外可中断预清理会在Eden达到50%的时候开始，这时候离下一次minor gc还有半程的时间，这个还有另一个意义，即避免短时间内连着的两个停顿，如下图资料所示：
    
    避免连续停顿的发生
    
      
    
    在预清理步骤后，如果满足下面两个条件，就不会开启可中断的预清理，直接进入重新标记阶段：
    
    *   Eden的使用空间大于“CMSScheduleRemarkEdenSizeThreshold”，这个参数的默认值是2M；
    *   Eden的使用率大于等于“CMSScheduleRemarkEdenPenetration”，这个参数的默认值是50%。
    
    如果不满足上面两个条件，则进入可中断的预清理，可中断预清理可能会执行多次，那么退出这个阶段的出口有两个（源码参见下图）：
    
    *   设置了CMSMaxAbortablePrecleanLoops，并且执行的次数超过了这个值，这个参数的默认值是0；
        
    *   CMSMaxAbortablePrecleanTime，执行可中断预清理的时间超过了这个值，这个参数的默认值是5000毫秒。
        
        可中断预清理退出的条件
        
        如果是因为这个原因退出，gc日志打印如下：
        
        可中断预清理由于时间退出
        
        有可能可中断预清理过程中一直没等到Minor gc，这时候进入重新标记阶段的话，新生代还有很多活着的对象，就回导致STW变长，因此CMS还提供了_CMSScavengeBeforeRemark_参数，可以在进入重新标记之前强制进行依次Minor gc。
        
5.  （STW）重新标记：重新扫描堆中的对象，进行可达性分析,标记活着的对象。这个阶段扫描的目标是：新生代的对象 + Gc Roots + 前面被标记为dirty的card对应的老年代对象。如果预清理的工作没做好，这一步扫描新生代的时候就会花很多时间，导致这个阶段的停顿时间过长。这个过程是多线程的。
    
6.  并发清除：用户线程被重新激活，同时将那些未被标记为存活的对象标记为不可达；
    
7.  并发重置：CMS内部重置回收器状态，准备进入下一个并发回收周期。
    

#### CMS的异常情况

上面描述的是CMS的并发周期正常完成的情况，但是还有几种CMS并发周期失败的情况：

1.  并发模式失败（Concurrent mode failure）：CMS的目标就是在回收老年代对象的时候不要停止全部应用线程，在并发周期执行期间，用户的线程依然在运行，如果这时候如果应用线程向老年代请求分配的空间超过预留的空间（担保失败），就回触发concurrent mode failure，然后CMS的并发周期就会被一次Full GC代替——停止全部应用进行垃圾收集，并进行空间压缩。如果我们设置了_UseCMSInitiatingOccupancyOnly_和_CMSInitiatingOccupancyFraction_参数，其中_CMSInitiatingOccupancyFraction_的值是70，那预留空间就是老年代的30%。
2.  晋升失败：新生代做minor gc的时候，需要CMS的担保机制确认老年代是否有足够的空间容纳要晋升的对象，担保机制发现不够，则报concurrent mode failure，如果担保机制判断是够的，但是实际上由于碎片问题导致无法分配，就会报晋升失败。
3.  永久代空间（或Java8的元空间）耗尽，默认情况下,CMS不会对永久代进行收集，一旦永久代空间耗尽，就回触发Full GC。

### 三、CMS的调优

1.  针对停顿时间过长的调优  
    首先需要判断是哪个阶段的停顿导致的，然后再针对具体的原因进行调优。使用CMS收集器的JVM可能引发停顿的情况有：（1）Minor gc的停顿；（2）并发周期里初始标记的停顿；（3）并发周期里重新标记的停顿；（4）Serial-Old收集老年代的停顿；（5）Full GC的停顿。其中并发模式失败会导致第（4）种情况，晋升失败和永久代空间耗尽会导致第（5）种情况。
2.  针对并发模式失败的调优
    *   想办法增大老年代的空间，增加整个堆的大小，或者减少年轻代的大小
        
    *   以更高的频率执行后台的回收线程，即提高CMS并发周期发生的频率。设置_UseCMSInitiatingOccupancyOnly_和_CMSInitiatingOccupancyFraction_参数，调低_CMSInitiatingOccupancyFraction_的值，但是也不能调得太低，太低了会导致过多的无效的并发周期，会导致消耗CPU时间和更多的无效的停顿。通常来讲，这个过程需要几个迭代，但是还是有一定的套路，参见《Java性能权威指南》中给出的建议，摘抄如下：
        
        > 对特定的应用程序，该标志的更优值可以根据 GC 日志中 CMS 周期首次启动失败时的值得到。具体方法是，在垃圾回收日志中寻找并发模式失效，找到后再反向查找 CMS 周期最近的启动记录，然后根据日志来计算这时候的老年代空间占用值，然后设置一个比该值更小的值。
        
    *   增多回收线程的个数  
        CMS默认的垃圾收集线程数是_（CPU个数 + 3）/4_，这个公式的含义是：当CPU个数大于4个的时候，垃圾回收后台线程至少占用25%的CPU资源。举个例子：如果CPU核数是1-4个，那么会有1个CPU用于垃圾收集，如果CPU核数是5-8个，那么久会有2个CPU用于垃圾收集。
        
3.  针对永久代的调优  
    如果永久代需要垃圾回收（或元空间扩容），就会触发Full GC。默认情况下，CMS不会处理永久代中的垃圾，可以通过开启_CMSPermGenSweepingEnabled_配置来开启永久代中的垃圾回收，开启后会有一组后台线程针对永久代做收集，需要注意的是，触发永久代进行垃圾收集的指标跟触发老年代进行垃圾收集的指标是独立的，老年代的阈值可以通过_CMSInitiatingPermOccupancyFraction_参数设置，这个参数的默认值是80%。开启对永久代的垃圾收集只是其中的一步，还需要开启另一个参数——_CMSClassUnloadingEnabled_，使得在垃圾收集的时候可以卸载不用的类。

### 四、CMS的trade-off是什么？

1.  优势
    *   低延迟的收集器：几乎没有长时间的停顿，应用程序只在Minor gc以及后台线程扫描老年代的时候发生极其短暂的停顿。
2.  劣势
    *   更高的CPU使用：必须有足够的CPU资源用于运行后台的垃圾收集线程，在应用程序线程运行的同时扫描堆的使用情况。【PS：现在服务器的CPU资源基本不是问题，这个点可以忽略】
    *   CMS收集器对老年代收集的时候，不再进行任何压缩和整理的工作，意味着老年代随着应用的运行会变得**碎片化**；碎片过多会影响大对象的分配，虽然老年代还有很大的剩余空间，但是没有连续的空间来分配大对象，这时候就会触发_Full GC_。CMS提供了两个参数来解决这个问题：（1）_UseCMSCompactAtFullCollection_，在要进行Full GC的时候进行内存碎片整理；（2）_CMSFullGCsBeforeCompaction_，每隔多少次不压缩的Full GC后，执行一次带压缩的Full GC。
    *   会出现**浮动垃圾**；在并发清理阶段，用户线程仍然在运行，必须预留出空间给用户线程使用，因此CMS比其他回收器需要更大的堆空间。

### 五、几个问题的解答

1.  为什么ParNew可以和CMS配合使用，而Parallel Scanvenge不可以？  
    答：这个跟Hotspot VM的历史有关，Parallel Scanvenge是不在“分代框架”下开发的，而ParNew、CMS都是在分代框架下开发的。
    
2.  CMS中minor gc和major gc是顺序发生的吗？  
    答：不是的，可以交叉发生，即在并发周期执行过程中，是可以发生Minor gc的，这个找个gc日志就可以观察到。
    
3.  CMS的并发收集周期合适触发？  
    
    由下图可以看出，CMS 并发周期触发的条件有两个：
    
    触发cms并发周期的条件
    
    *   阈值检查机制：老年代的使用空间达到某个阈值，JVM的默认值是92%（jdk1.5之前是68%，jdk1.6之后是92%），或者可以通过CMSInitiatingOccupancyFraction和UseCMSInitiatingOccupancyOnly两个参数来设置；这个参数的设置需要看应用场景，设置得太小，会导致CMS频繁发生，设置得太大，会导致过多的并发模式失败。例如
    *   动态检查机制：JVM会根据最近的回收历史，估算下一次老年代被耗尽的时间，快到这个时间的时候就启动一个并发周期。设置_UseCMSInitiatingOccupancyOnly_这个参数可以将这个特性关闭。
4.  CMS的并发收集周期会扫描哪些对象？会回收哪些对象？  
    答：CMS的并发周期只会回收老年代的对象，但是在标记老年代的存活对象时，可能有些对象会被年轻代的对象引用，因此需要扫描整个堆的对象。
    
5.  CMS的gc roots包括哪些对象？  
    答：首先，在JVM垃圾收集中Gc Roots的概念如何理解(参见[R大对GC roots的概念的解释](https://www.zhihu.com/question/53613423/answer/135743258))；第二，CMS的并发收集周期中，如何判断老年代的对象是活着？我们前面提到了，在CMS的并发周期中，仅仅扫描Gc Roots直达的对象会有遗漏，还需要扫描新生代的对象。如下图中的蓝色字体所示，CMS中的年轻代和老年代是分别收集的，因此在判断年轻代的对象存活的时候，需要把老年代当作自己的GcRoots，这时候并不需要扫描老年代的全部对象，而是使用了card table数据结构，如果一个老年代对象引用了年轻代的对象，则card中的值会被设置为特殊的数值；反过来判断老年代对象存活的时候，也需要把年轻代当作自己的Gc Roots，这个过程我们在第三节已经论述过了。
    
    老年代和新生代互相作为Gc Roots
    

6.  如果我的应用决定使用CMS收集器，推荐的JVM参数是什么？我自己的应用使用的参数如下，是根据PerfMa的[xxfox](http://xxfox.perfma.com/)生成的，大家也可以使用这个产品调优自己的JVM参数：
    
        -Xmx4096M -Xms4096M -Xmn1536M 
        -XX:MaxMetaspaceSize=512M -XX:MetaspaceSize=512M 
        -XX:+UseConcMarkSweepGC 
        -XX:+UseCMSInitiatingOccupancyOnly 
        -XX:CMSInitiatingOccupancyFraction=70 
        -XX:+ExplicitGCInvokesConcurrentAndUnloadsClasses 
        -XX:+CMSClassUnloadingEnabled 
        -XX:+ParallelRefProcEnabled 
        -XX:+CMSScavengeBeforeRemark 
        -XX:ErrorFile=/home/admin/logs/xelephant/hs_err_pid%p.log 
        -Xloggc:/home/admin/logs/xelephant/gc.log 
        -XX:HeapDumpPath=/home/admin/logs/xelephant 
        -XX:+PrintGCDetails 
        -XX:+PrintGCDateStamps 
        -XX:+HeapDumpOnOutOfMemoryError
        
    
7.  CMS相关的参数总结（需要注意的是，这里我没有考虑太多JDK版本的问题，JDK1.7和JDK1.8这些参数的配置，有些默认值可能不一样，具体使用的时候还需要根据具体的版本来确认怎么设置）
    
    编号
    
    参数名称
    
    解释
    
    1
    
    UseConcMarkSweepGC
    
    启用CMS收集器
    
    2
    
    UseCMSInitiatingOccupancyOnly
    
    关闭CMS的动态检查机制，只通过预设的阈值来判断是否启动并发收集周期
    
    3
    
    CMSInitiatingOccupancyFraction
    
    老年代空间占用到多少的时候启动并发收集周期，跟UseCMSInitiatingOccupancyOnly一起使用
    
    4
    
    ExplicitGCInvokesConcurrentAndUnloadsClasses
    
    将System.gc()触发的Full GC转换为一次CMS并发收集，并且在这个收集周期中卸载 Perm（Metaspace）区域中不需要的类
    
    5
    
    CMSClassUnloadingEnabled
    
    在CMS收集周期中，是否卸载类
    
    6
    
    ParallelRefProcEnabled
    
    是否开启并发引用处理
    
    7
    
    CMSScavengeBeforeRemark
    
    如果开启这个参数，会在进入重新标记阶段之前强制触发一次minor gc
    

### 参考资料

1.  [从实际案例聊聊Java应用的GC优化](https://tech.meituan.com/jvm_optimize.html)
2.  [理解CMS垃圾回收日志](http://ifeve.com/jvm-cms-log/)
3.  [图解CMS垃圾回收机制，你值得拥有](https://www.jianshu.com/p/2a1b2f17d3e4)
4.  [为什么CMS虽然是老年代的gc，但仍要扫描新生代的?](https://www.zhihu.com/question/279580656/answer/408089811)
5.  [R大对GC roots的概念的解释](https://www.zhihu.com/question/53613423/answer/135743258)
6.  [Introduce to CMS Collector](https://medium.com/@robiplus/introduce-to-cms-collector-47b4400665c3)
7.  《深入理解Java虚拟机》
8.  《Java性能权威指南》
9.  [Oracle的GC调优手册](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html)
10.  [what-is-the-threshold-for-cms-old-gc-to-be-triggered](https://stackoverflow.com/questions/33557644/what-is-the-threshold-for-cms-old-gc-to-be-triggered)
11.  [Frequently Asked Questions about Garbage Collection in the Hotspot Java VirtualMachine](https://www.oracle.com/technetwork/java/faq-140837.html)
12.  [Java SE HotSpot at a Glance](https://www.oracle.com/technetwork/java/javase/tech/index-jsp-136373.html)
13.  [xxfox：PerfMa的参数调优神器](http://xxfox.perfma.com/)
14.  [详解CMS垃圾回收机制](https://www.cnblogs.com/littleLord/p/5380624.html)
15.  [ParNew和PSYoungGen和DefNew是一个东西么？](http://hllvm.group.iteye.com/group/topic/37095#post-242695)
16.  [Java SE的内存管理白皮书](https://www.oracle.com/technetwork/java/javase/memorymanagement-whitepaper-150215.pdf)
17.  [Garbage Collection in Elasticsearch and the G1GC](https://medium.com/naukri-engineering/garbage-collection-in-elasticsearch-and-the-g1gc-16b79a447181)
18.  [A Heap of Trouble](https://www.elastic.co/cn/blog/a-heap-of-trouble)
19.  [毕玄的文章：为什么不建议](http://hellojava.info/?p=142)
20.  [JVM源码分析之SystemGC完全解读](http://lovestblog.cn/blog/2015/05/07/system-gc/)

### 读者讨论

1.  关于CMS收集器的回收范围，下面这张图是有误导的，从官方文档上看来，CMS收集器包括年轻代和老年代的收集，只不过对年轻代的收集的策略和ParNew相同，这个可以从参考资料16的第11页看到。
    
    image.png
    
    image.png
    
2.  concurrent mode failure和promotion failed触发的Full GC有啥不同？(这个问题是我、阿飞、蒋晓峰一起讨论的结果)  
    答：concurrent mode failure触发的"Full GC"不是我们常说的Full GC——正常的Full GC其实是整个gc过程包括ygc和cms gc。也就是说，这个问题本身是有问题的，concurrent mode failure的时候触发的并不是我们常说的Full GC。然后再去讨论一个遗漏的知识点：CMS gc的并发周期有两种模式：foreground和background。
    
    *   concurrent mode failure触发的是foreground模式，会暂停整个应用，会将一些并行的阶段省掉做一次老年代收集，行为跟Serial-Old的一样，至于在这个过程中是否需要压缩，则需要看三个条件：（1）我们设置了_UseCMSCompactAtFullCollection_和_CMSFullGCsBeforeCompaction_，前者设置为true，后者默认是0，前者表示是在Full GC的时候执行压缩，后者表示是每隔多少个进行压缩，默认是0的话就是每次Full GC都压缩；（2）用户调用了System.gc()，而且DisableExplicitGC没有开启；（3）young gen报告接下来如果做增量收集会失败。
        
        image.png
        
    *   promotion failed触发的是我们常说的的Full GC，对年轻代和老年代都会回收，并进行整理。
3.  promotion failed和concurrent mode failure的触发原因有啥不同？
    
    *   promotion failed是说，担保机制确定老年代是否有足够的空间容纳新来的对象，如果担保机制说有，但是真正分配的时候发现由于碎片导致找不到连续的空间而失败；
    *   concurrent mode failure是指并发周期还没执行完，用户线程就来请求比预留空间更大的空间了，即后台线程的收集没有赶上应用线程的分配速度。
4.  什么情况下才选择使用CMS收集器呢？我之前的观念是：小于8G的都用CMS，大于8G的选择G1。蒋晓峰跟我讨论了下这个观念，提出了一些别的想法，我觉得也有道理，记录在这里：
    
    *   除了看吞吐量和延时，还需要看具体的应用，比方说ES，Lucene和G1是不兼容的，因此默认的收集器就是CMS，具体见可参考资料17和18。
    *   小于3G的堆，如果不是对延迟有特别高的需求，不建议使用CMS，主要是由于CMS的几个缺点导致的：（1）并发周期的触发比例不好设置；（2）抢占CPU时间；（3）担保判断导致YGC变慢；（4）碎片问题，更详细的讨论参见资料19。
