# JDK的命令行工具

## 常用命令：

这里主要介绍如下几个工具：

* 1、jps：查看本机java进程信息。

* 2、jstack：打印线程的栈信息，制作线程dump文件。

* 3、jmap：打印内存映射，制作堆dump文件

* 4、jstat：性能监控工具

* 5、jhat：内存分析工具

* 6、jconsole：简易的可视化控制台

* 7、jvisualvm：功能强大的控制台


--------------------------------
# Jcmd 综合工具

```
jcmd -l  列出当前运行的所有虚拟机

参数-l表示列出所有java虚拟机
```
针对每一个虚拟机，可以使用help命令列出该虚拟机支持的所有命令

```
jcmd [pid] help
```
查看虚拟机启动时间VM.uptime

```
jcmd [pid] VM.uptime   

```
打印线程栈信息Thread.print
```
jcmd [pid] Thread.print  
```
导出堆信息GC.heap_dump  这个命令功能和 jmap -dump 功能一样

```
jcmd [pid] GC.heap_dump [filepath&name]  
```

获取系统Properties内容VM.system_properties
```
jcmd [pid] VM.system_properties 
```
获取启动参数VM.flags
```
jcmd [pid] VM.flags 
```
获取所有性能相关数据PerfCounter.print
```
jcmd [pid] PerfCounter.print  
```
------------------------------------

# jps 虚拟机进程状况工具


jps（JVM Process Status Tool）可以列出正在运行的虚拟机进程，并显示虚拟机执行主类（Main Class,main()函数所在的类）名称以及这些进程的本地虚拟机唯一ID（Local Virtual Machine Identifier,LVMID）。虽然功能比较单一，但它是使用频率最高的JDK命令行工具，因为其他的JDK工具大多需要输入它查询到的LVMID来确定要监控的是哪一个虚拟机进程。对于本地虚拟机进程来说，LVMID与操作系统的进程ID（Process Identifier,PID）是一致的，使用Windows的任务管理器或者UNIX的ps命令也可以查询到虚拟机进程的LVMID，但如果同时启动了多个虚拟机进程，无法根据进程名称定位时，那就只能依赖jps命令显示主类的功能才能区分了。

命令格式

 jps [options] [hostid]

option参数

-l : 输出主类全名或jar路径

-q : 只输出LVMID

-m : 输出JVM启动时传递给main()的参数

-v : 输出JVM启动时显示指定的JVM参数

其中[option]、[hostid]参数也可以不写。



# jinfo

jinfo(JVM Configuration info)这个命令作用是实时查看和调整虚拟机运行参数。 之前的jps -v口令只能查看到显示指定的参数，如果想要查看未被显示指定的参数的值就要使用jinfo口令 

命令格式

jinfo [option] [args] LVMID

option参数

-flag : 输出指定args参数的值

-flags : 不需要args参数，输出所有JVM参数的值

-sysprops : 输出系统属性，等同于System.getProperties()

示例

$ jinfo -flag 11494

-XX:CMSInitiatingOccupancyFraction=80



# jstat 虚拟机统计信息监视工具

jstat(JVM statistics Monitoring)是用于监视虚拟机运行时状态信息的命令，它可以显示出虚拟机进程中的类装载、内存、垃圾收集、JIT编译等运行数据。

命令格式

 jstat [option] LVMID [interval] [count]

参数

[option] : 操作参数

LVMID : 本地虚拟机进程ID

[interval] : 连续输出的时间间隔

[count] : 连续输出的次数

对于命令格式中的VMID与LVMID需要特别说明一下：

如果是本地虚拟机进程，VMID与LVMID是一致的;

如果是远程虚拟机进程，那VMID的格式应当是：protocol://lvmid@hostname:port/servername

参数interval和count代表查询间隔(单位毫秒)和次数，如果省略这两个参数，说明只查询一次。

假设需要每250毫秒查询一次进程2764垃圾收集状况，一共查询20次，那命令应当是：jstat -gc 2764 250 20

选项option代表着用户希望查询的虚拟机信息，主要分为3类：类装载、垃圾收集、运行期编译状况，具体选项及作用请参考表4-3中的描述。





## 查看java进程

```
jps -v
```

## jinfo <PID>

```
jinfo PID
```


## JMX 配置

```shell
-Xms1024m -Xmx2048m -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false
```
## java -X 命令
查看JVM的配置说明：运行后如下结果，这些就是配置JVM参数的秘密武器，这些信息都是英文的，为了方便阅读，我根据自己的理解翻译成中文了.
```
-----------------------------------------------------------------------
D:\j2sdk15\bin>java -X
    -Xmixed           mixed mode execution (default)
    -Xint             interpreted mode execution only
    -Xbootclasspath:<directories and zip/jar files separated by ;>
                      set search path for bootstrap classes and resources
    -Xbootclasspath/a:<directories and zip/jar files separated by ;>
                      append to end of bootstrap class path
    -Xbootclasspath/p:<directories and zip/jar files separated by ;>
                      prepend in front of bootstrap class path
    -Xnoclassgc       disable class garbage collection
    -Xincgc           enable incremental garbage collection
    -Xloggc:<file>    log GC status to a file with time stamps
    -Xbatch           disable background compilation
    -Xms<size>        set initial Java heap size
    -Xmx<size>        set maximum Java heap size
    -Xss<size>        set java thread stack size
    -Xprof            output cpu profiling data
    -Xfuture          enable strictest checks, anticipating future default
    -Xrs              reduce use of OS signals by Java/VM (see documentation)
    -Xcheck:jni       perform additional checks for JNI functions
    -Xshare:off       do not attempt to use shared class data
    -Xshare:auto      use shared class data if possible (default)
    -Xshare:on        require using shared class data, otherwise fail.
 
The -X options are non-standard and subject to change without notice.
-----------------------------------------------------------------------
```
 
JVM配置参数中文说明：
-----------------------------------------------------------------------
1、-Xmixed           mixed mode execution (default)
 混合模式执行
 
2、-Xint             interpreted mode execution only
 解释模式执行
 
3、-Xbootclasspath:<directories and zip/jar files separated by ;>
      set search path for bootstrap classes and resources
 设置zip/jar资源或者类（.class文件）存放目录路径
 
3、-Xbootclasspath/a:<directories and zip/jar files separated by ;>
      append to end of bootstrap class path
 追加zip/jar资源或者类（.class文件）存放目录路径
 
4、-Xbootclasspath/p:<directories and zip/jar files separated by ;>
      prepend in front of bootstrap class path
 预先加载zip/jar资源或者类（.class文件）存放目录路径
 
5、-Xnoclassgc       disable class garbage collection
 关闭类垃圾回收功能
 
6、-Xincgc           enable incremental garbage collection
 开启类的垃圾回收功能
 
7、-Xloggc:<file>    log GC status to a file with time stamps
 记录垃圾回日志到一个文件。
 
8、-Xbatch           disable background compilation
 关闭后台编译
 
9、-Xms<size>        set initial Java heap size
 设置JVM初始化堆内存大小
 
10、-Xmx<size>        set maximum Java heap size
 设置JVM最大的堆内存大小
 
11、-Xss<size>        set java thread stack size
 设置JVM栈内存大小
 
12、-Xprof            output cpu profiling data
 输入CPU概要表数据
 
13、-Xfuture          enable strictest checks, anticipating future default
 执行严格的代码检查，预测可能出现的情况
 
14、-Xrs              reduce use of OS signals by Java/VM (see documentation)
 通过JVM还原操作系统信号
 
15、-Xcheck:jni       perform additional checks for JNI functions
 对JNI函数执行检查
 
16、-Xshare:off       do not attempt to use shared class data
 尽可能不去使用共享类的数据
 
17、-Xshare:auto      use shared class data if possible (default)
 尽可能的使用共享类的数据
 
18、-Xshare:on       require using shared class data, otherwise fail.
 尽可能的使用共享类的数据，否则运行失败
 
The -X options are non-standard and subject to change without notice.
-----------------------------------------------------------------------
 
怎么用这这些参数呢？其实所有的命令行都是这么一用，下面我就给出一个最简单的HelloWorl的例子来演示这个参数的用法，非常的简单。
```
HelloWorld.java
-----------------------------------------------
public class  HelloWorld
{
 public static void main(String[] args)
 {
  System.out.println("Hello World!");
 }
}
```
编译并运行：
```
D:\j2sdk15\bin>javac HelloWorld.java
 
D:\j2sdk15\bin>java -Xms256M -Xmx512M HelloWorld
Hello World!
```
## java -verbose命令

java -verbose[:class|gc|jni] 在输出设备上显示虚拟机运行信息。

* 1、 `-verbose:class`
在程序运行的时候究竟会有多少类被加载呢，一个简单程序会加载上百个类的！你可以用verbose:class来监视，在启动参数中加上 -verbose:class 可以查看到加载的类的情况。

* 2、 `–verbose:gc`

在启动参数中加上 -verbose:gc 当发生gc时，可以打印出gc相关的信息；该信息不够高全面，等同于-XX:+PrintGC。其实只要设置-XX:+PrintGCDetails 就会自动带上-verbose:gc和-XX:+PrintGC

* 3、`–verbose:jni`

输出native方法调用的相关情况，一般用于诊断jni调用错误信息。在虚拟机调用native方法时输出设备显示信息，格式如下： [Dynamic-linking native method HelloNative.sum ... JNI] 该参数用来监视虚拟机调用本地方法的情况，在发生jni错误时可为诊断提供便利。
 
