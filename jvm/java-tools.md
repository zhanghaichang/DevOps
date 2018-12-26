# Java Tools


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
 
