目录

*   [常用日志框架](#常用日志框架)
*   [日志门面slf4j](#日志门面slf4j)
*   [为什么选用log4j2](#为什么选用log4j2)
*   [整合步骤](#整合步骤)
    *   [引入Jar包](#引入jar包)
    *   [配置文件](#配置文件)
    *   [配置文件模版](#配置文件模版)
*   [配置参数简介](#配置参数简介)
*   [Log4j2配置详解](#log4j2配置详解)
*   [简单使用](#简单使用)
*   [使用lombok工具简化创建Logger类](#使用lombok工具简化创建logger类)
*   [参考文章](#参考文章)

> 在项目推进中，如果说第一件事是搭Spring框架的话，那么第二件事情就是在Sring基础上搭建日志框架，我想很多人都知道日志对于一个项目的重要性，尤其是线上Web项目，因为日志可能是我们了解应用如何执行的唯一方式。**在18年大环境下，更多的企业使用Springboot和Springcloud来搭建他们的企业微服务项目**，此篇文章是博主在实践中用Springboot整合log4j2日志的总结。

常用日志框架
------

*   java.util.logging：是JDK在1.4版本中引入的Java原生日志框架
*   Log4j：Apache的一个开源项目，可以控制日志信息输送的目的地是控制台、文件、GUI组件等，可以控制每一条日志的输出格式，这些可以通过一个配置文件来灵活地进行配置，而不需要修改应用的代码。虽然已经停止维护了，但目前绝大部分企业都是用的log4j。
*   LogBack：是Log4j的一个改良版本
*   Log4j2：Log4j2已经不仅仅是Log4j的一个升级版本了，它从头到尾都被重写了

日志门面slf4j
---------

> 上述介绍的是一些日志框架的实现，这里我们需要用日志门面来解决系统与日志实现框架的耦合性。SLF4J，即简单日志门面（Simple Logging Facade for Java），它不是一个真正的日志实现，而是一个抽象层（ abstraction layer），它允许你在后台使用任意一个日志实现。

![](http://axin-soochow.oss-cn-hangzhou.aliyuncs.com/18-12-3/35274748.jpg)

前面介绍的几种日志框架一样，每一种日志框架都有自己单独的API，要使用对应的框架就要使用其对应的API，这就大大的增加应用程序代码对于日志框架的耦合性。

使用了slf4j后，对于应用程序来说，无论底层的日志框架如何变，应用程序不需要修改任意一行代码，就可以直接上线了。

为什么选用log4j2
-----------

> 相比与其他的日志系统，log4j2丢数据这种情况少；disruptor技术，在多线程环境下，性能高于logback等10倍以上；利用jdk1.5并发的特性，减少了死锁的发生；

在这列举一下一些网上其他博文中对它们的性能评测：

![](http://axin-soochow.oss-cn-hangzhou.aliyuncs.com/18-12-10/45608002.jpg)

*   可以看到在同步日志模式下, Logback的性能是最糟糕的.
*   log4j2的性能无论在同步日志模式还是异步日志模式下都是最佳的.

![](http://axin-soochow.oss-cn-hangzhou.aliyuncs.com/18-12-10/31312446.jpg)

log4j2优越的性能其原因在于log4j2使用了LMAX,一个无锁的线程间通信库代替了,logback和log4j之前的队列. 并发性能大大提升。

整合步骤
----

### 引入Jar包

> springboot默认是用logback的日志框架的，所以需要排除logback，不然会出现jar依赖冲突的报错。

    <dependency>  
        <groupId>org.springframework.boot</groupId>  
        <artifactId>spring-boot-starter-web</artifactId>  
        <exclusions><!-- 去掉springboot默认配置 -->  
            <exclusion>  
                <groupId>org.springframework.boot</groupId>  
                <artifactId>spring-boot-starter-logging</artifactId>  
            </exclusion>  
        </exclusions>  
    </dependency> 
    
    <dependency> <!-- 引入log4j2依赖 -->  
        <groupId>org.springframework.boot</groupId>  
        <artifactId>spring-boot-starter-log4j2</artifactId>  
    </dependency> 

### 配置文件

1.  如果自定义了文件名，需要在application.yml中配置

    logging:
      config: xxxx.xml
      level:
    ​    cn.jay.repository: trace

1.  默认名log4j2-spring.xml，就省下了在application.yml中配置

### 配置文件模版

> log4j是通过一个.properties的文件作为主配置文件的，而现在的log4j2则已经弃用了这种方式，采用的是.xml，.json或者.jsn这种方式来做，可能这也是技术发展的一个必然性，因为properties文件的可阅读性真的是有点差。这里给出博主自配的一个模版，供大家参考。

    <?xml version="1.0" encoding="UTF-8"?>
    <!--Configuration后面的status，这个用于设置log4j2自身内部的信息输出，可以不设置，当设置成trace时，你会看到log4j2内部各种详细输出-->
    <!--monitorInterval：Log4j能够自动检测修改配置 文件和重新配置本身，设置间隔秒数-->
    <configuration monitorInterval="5">
      <!--日志级别以及优先级排序: OFF > FATAL > ERROR > WARN > INFO > DEBUG > TRACE > ALL -->
    
      <!--变量配置-->
      <Properties>
        <!-- 格式化输出：%date表示日期，%thread表示线程名，%-5level：级别从左显示5个字符宽度 %msg：日志消息，%n是换行符-->
        <!-- %logger{36} 表示 Logger 名字最长36个字符 -->
        <property name="LOG_PATTERN" value="%date{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n" />
        <!-- 定义日志存储的路径，不要配置相对路径 -->
        <property name="FILE_PATH" value="更换为你的日志路径" />
        <property name="FILE_NAME" value="更换为你的项目名" />
      </Properties>
    
      <appenders>
    
        <console name="Console" target="SYSTEM_OUT">
          <!--输出日志的格式-->
          <PatternLayout pattern="${LOG_PATTERN}"/>
          <!--控制台只输出level及其以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
          <ThresholdFilter level="info" onMatch="ACCEPT" onMismatch="DENY"/>
        </console>
    
        <!--文件会打印出所有信息，这个log每次运行程序会自动清空，由append属性决定，适合临时测试用-->
        <File name="Filelog" fileName="${FILE_PATH}/test.log" append="false">
          <PatternLayout pattern="${LOG_PATTERN}"/>
        </File>
    
        <!-- 这个会打印出所有的info及以下级别的信息，每次大小超过size，则这size大小的日志会自动存入按年份-月份建立的文件夹下面并进行压缩，作为存档-->
        <RollingFile name="RollingFileInfo" fileName="${FILE_PATH}/info.log" filePattern="${FILE_PATH}/${FILE_NAME}-INFO-%d{yyyy-MM-dd}_%i.log.gz">
          <!--控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
          <ThresholdFilter level="info" onMatch="ACCEPT" onMismatch="DENY"/>
          <PatternLayout pattern="${LOG_PATTERN}"/>
          <Policies>
            <!--interval属性用来指定多久滚动一次，默认是1 hour-->
            <TimeBasedTriggeringPolicy interval="1"/>
            <SizeBasedTriggeringPolicy size="10MB"/>
          </Policies>
          <!-- DefaultRolloverStrategy属性如不设置，则默认为最多同一文件夹下7个文件开始覆盖-->
          <DefaultRolloverStrategy max="15"/>
        </RollingFile>
    
        <!-- 这个会打印出所有的warn及以下级别的信息，每次大小超过size，则这size大小的日志会自动存入按年份-月份建立的文件夹下面并进行压缩，作为存档-->
        <RollingFile name="RollingFileWarn" fileName="${FILE_PATH}/warn.log" filePattern="${FILE_PATH}/${FILE_NAME}-WARN-%d{yyyy-MM-dd}_%i.log.gz">
          <!--控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
          <ThresholdFilter level="warn" onMatch="ACCEPT" onMismatch="DENY"/>
          <PatternLayout pattern="${LOG_PATTERN}"/>
          <Policies>
            <!--interval属性用来指定多久滚动一次，默认是1 hour-->
            <TimeBasedTriggeringPolicy interval="1"/>
            <SizeBasedTriggeringPolicy size="10MB"/>
          </Policies>
          <!-- DefaultRolloverStrategy属性如不设置，则默认为最多同一文件夹下7个文件开始覆盖-->
          <DefaultRolloverStrategy max="15"/>
        </RollingFile>
    
        <!-- 这个会打印出所有的error及以下级别的信息，每次大小超过size，则这size大小的日志会自动存入按年份-月份建立的文件夹下面并进行压缩，作为存档-->
        <RollingFile name="RollingFileError" fileName="${FILE_PATH}/error.log" filePattern="${FILE_PATH}/${FILE_NAME}-ERROR-%d{yyyy-MM-dd}_%i.log.gz">
          <!--控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
          <ThresholdFilter level="error" onMatch="ACCEPT" onMismatch="DENY"/>
          <PatternLayout pattern="${LOG_PATTERN}"/>
          <Policies>
            <!--interval属性用来指定多久滚动一次，默认是1 hour-->
            <TimeBasedTriggeringPolicy interval="1"/>
            <SizeBasedTriggeringPolicy size="10MB"/>
          </Policies>
          <!-- DefaultRolloverStrategy属性如不设置，则默认为最多同一文件夹下7个文件开始覆盖-->
          <DefaultRolloverStrategy max="15"/>
        </RollingFile>
    
      </appenders>
    
      <!--Logger节点用来单独指定日志的形式，比如要为指定包下的class指定不同的日志级别等。-->
      <!--然后定义loggers，只有定义了logger并引入的appender，appender才会生效-->
      <loggers>
    
        <!--过滤掉spring和mybatis的一些无用的DEBUG信息-->
        <logger name="org.mybatis" level="info" additivity="false">
          <AppenderRef ref="Console"/>
        </logger>
        <!--监控系统信息-->
        <!--若是additivity设为false，则 子Logger 只会在自己的appender里输出，而不会在 父Logger 的appender里输出。-->
        <Logger name="org.springframework" level="info" additivity="false">
          <AppenderRef ref="Console"/>
        </Logger>
    
        <root level="info">
          <appender-ref ref="Console"/>
          <appender-ref ref="Filelog"/>
          <appender-ref ref="RollingFileInfo"/>
          <appender-ref ref="RollingFileWarn"/>
          <appender-ref ref="RollingFileError"/>
        </root>
      </loggers>
    
    </configuration>

配置参数简介
------

> 在这里简单介绍下常用的配置参数

1.  日志级别
    
    > 机制：如果一条日志信息的级别大于等于配置文件的级别，就记录。
    

*   trace：追踪，就是程序推进一下，可以写个trace输出
*   debug：调试，一般作为最低级别，trace基本不用。
*   info：输出重要的信息，使用较多
*   warn：警告，有些信息不是错误信息，但也要给程序员一些提示。
*   error：错误信息。用的也很多。
*   fatal：致命错误。

1.  输出源

*   CONSOLE（输出到控制台）
*   FILE（输出到文件）

1.  格式

*   SimpleLayout：以简单的形式显示
*   HTMLLayout：以HTML表格显示
*   PatternLayout：自定义形式显示

PatternLayout自定义日志布局：

    %d{yyyy-MM-dd HH:mm:ss, SSS} : 日志生产时间,输出到毫秒的时间
    %-5level : 输出日志级别，-5表示左对齐并且固定输出5个字符，如果不足在右边补0
    %c : logger的名称(%logger)
    %t : 输出当前线程名称
    %p : 日志输出格式
    %m : 日志内容，即 logger.info("message")
    %n : 换行符
    %C : Java类名(%F)
    %L : 行号
    %M : 方法名
    %l : 输出语句所在的行数, 包括类名、方法名、文件名、行数
    hostName : 本地机器名
    hostAddress : 本地ip地址

Log4j2配置详解
----------

1.  根节点Configuration  
    有两个属性:

*   status
*   monitorinterval

有两个子节点:

*   Appenders
*   Loggers(表明可以定义多个Appender和Logger).

status用来指定log4j本身的打印日志的级别.  
monitorinterval用于指定log4j自动重新配置的监测间隔时间，单位是s,最小是5s.

1.  Appenders节点  
    常见的有三种子节点:Console、RollingFile、File

**Console节点用来定义输出到控制台的Appender**.

*   name:指定Appender的名字.
*   target:SYSTEM\_OUT 或 SYSTEM\_ERR,一般只设置默认:SYSTEM_OUT.
*   PatternLayout:输出格式，不设置默认为:%m%n.

**File节点用来定义输出到指定位置的文件的Appender**.

*   name:指定Appender的名字.
*   fileName:指定输出日志的目的文件带全路径的文件名.
*   PatternLayout:输出格式，不设置默认为:%m%n.

**RollingFile节点用来定义超过指定条件自动删除旧的创建新的Appender**.

*   name:指定Appender的名字.
*   fileName:指定输出日志的目的文件带全路径的文件名.
*   PatternLayout:输出格式，不设置默认为:%m%n.
*   filePattern : 指定当发生Rolling时，文件的转移和重命名规则.
*   Policies:指定滚动日志的策略，就是什么时候进行新建日志文件输出日志.
*   TimeBasedTriggeringPolicy:Policies子节点，基于时间的滚动策略，interval属性用来指定多久滚动一次，默认是1 hour。modulate=true用来调整时间：比如现在是早上3am，interval是4，那么第一次滚动是在4am，接着是8am，12am...而不是7am.
*   SizeBasedTriggeringPolicy:Policies子节点，基于指定文件大小的滚动策略，size属性用来定义每个日志文件的大小.
*   DefaultRolloverStrategy:用来指定同一个文件夹下最多有几个日志文件时开始删除最旧的，创建新的(通过max属性)。

**Loggers节点，常见的有两种:Root和Logger**.  
Root节点用来指定项目的根日志，如果没有单独指定Logger，那么就会默认使用该Root日志输出

*   level:日志输出级别，共有8个级别，按照从低到高为：All < Trace < Debug < Info < Warn < Error < AppenderRef：Root的子节点，用来指定该日志输出到哪个Appender.
*   Logger节点用来单独指定日志的形式，比如要为指定包下的class指定不同的日志级别等。
*   level:日志输出级别，共有8个级别，按照从低到高为：All < Trace < Debug < Info < Warn < Error < Fatal < OFF.
*   name:用来指定该Logger所适用的类或者类所在的包全路径,继承自Root节点.
*   AppenderRef：Logger的子节点，用来指定该日志输出到哪个Appender,如果没有指定，就会默认继承自Root.如果指定了，那么会在指定的这个Appender和Root的Appender中都会输出，此时我们可以设置Logger的additivity="false"只在自定义的Appender中进行输出。

简单使用
----

    public class LogExampleOther {
      private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(LogExampleOther.class);
      
      public static void main(String... args) {
        log.error("Something else is wrong here");
      }
    }

使用lombok工具简化创建Logger类
---------------------

> lombok就是一个注解工具jar包，能帮助我们省略一繁杂的代码。具体介绍可以看我的[这篇教程](https://www.cnblogs.com/keeya/p/9929617.html)。

使用lombok后下面的代码等效于上述的代码，这样会更方便的使用日志。

    @Slf4j
    public class LogExampleOther {
      
      public static void main(String... args) {
        log.error("Something else is wrong here");
      }
    }

参考文章
----

[为什么阿里巴巴禁止工程师直接使用日志系统(Log4j、Logback)中的 API](https://mp.weixin.qq.com/s/vCixKVXys5nTTcQQnzrs3w)

[logback log4j log4j2 性能实测](https://blog.csdn.net/yjh1271845364/article/details/70888262)
