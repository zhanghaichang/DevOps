## logback 日志


一 前言
====

logback是一个成熟的log4j 工程，由 Ceki Gülcü 所创造，也是 log4j 日志框架的创建者；

springboot`默认使用的日志框架是`logback，其由三个组件组成

*   logback-core
*   logback-classic
*   logback-access

logback-spring.xml 文件放在classpath （resource目录）下 即可自动加载

二logback 基本属性

```xml
    <configuration debug="true"> 
    
      <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender"> 
        <!-- encoders are  by default assigned the type
             ch.qos.logback.classic.encoder.PatternLayoutEncoder -->
        <encoder>
          <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
      </appender>
    
      <root level="debug">
        <appender-ref ref="STDOUT" />
      </root>
    </configuration>
    复制代码
```
日志格式说明

1.  %d 表示日期时间
2.  %thread表示线程名
3.  %-5level：级别从左显示5个字符宽度
4.  Logger ：通常使用源代码的类名
5.  %msg：日志消息
6.  %n是换行符

有效的日志级别如下
<table>
<thead>
<tr>
<th>level of request <em>p</em></th>
<th></th>
<th></th>
<th></th>
<th></th>
<th></th>
<th></th>
</tr>
</thead>
<tbody>
<tr>
<td></td>
<td>TRACE</td>
<td>DEBUG</td>
<td>INFO</td>
<td>WARN</td>
<td>ERROR</td>
<td>OFF</td>
</tr>
<tr>
<td>TRACE</td>
<td><strong>YES</strong></td>
<td><strong>NO</strong></td>
<td><strong>NO</strong></td>
<td><strong>NO</strong></td>
<td><strong>NO</strong></td>
<td><strong>NO</strong></td>
</tr>
<tr>
<td>DEBUG</td>
<td><strong>YES</strong></td>
<td><strong>YES</strong></td>
<td><strong>NO</strong></td>
<td><strong>NO</strong></td>
<td><strong>NO</strong></td>
<td><strong>NO</strong></td>
</tr>
<tr>
<td>INFO</td>
<td><strong>YES</strong></td>
<td><strong>YES</strong></td>
<td><strong>YES</strong></td>
<td><strong>NO</strong></td>
<td><strong>NO</strong></td>
<td><strong>NO</strong></td>
</tr>
<tr>
<td>WARN</td>
<td><strong>YES</strong></td>
<td><strong>YES</strong></td>
<td><strong>YES</strong></td>
<td><strong>YES</strong></td>
<td><strong>NO</strong></td>
<td><strong>NO</strong></td>
</tr>
<tr>
<td>ERROR</td>
<td><strong>YES</strong></td>
<td><strong>YES</strong></td>
<td><strong>YES</strong></td>
<td><strong>YES</strong></td>
<td><strong>YES</strong></td>
<td><strong>NO</strong></td>
</tr>
</tbody>
</table>

2.1 configuration 标签属性
----------------------

*   scan : 配置文件如果发生改变，将会被重新加载，默认值为true
```xml
    <configuration debug="true"> 
    	...
    </configuration>
```

*   debug: 实时查看logback运行状态，默认值为false
```xml
    <configuration scan="true"> 
      ... 
    </configuration>
```

*   scanPeriod: 监测配置文件是否有修改的时间间隔, 默认 每分钟；读者可以设置 示例`30 seconds`, `30 minutes`, `3 hours`
```xml
    <configuration scan="true" scanPeriod="30 seconds" > 
      ...
    </configuration> 
```

*   packagingData : 堆栈跟踪中是否启用打包数据，默认false;
```xml
    <configuration packagingData="true">
      ...
    </configuration>
```

2.2 statusListener 标签
---------------------
```xml
`statusListener` 为configuration 的子元素。称为状态监听器，在 configuration 的子标签顶层，意指监听事件；

    <configuration>
      <statusListener class="ch.qos.logback.core.status.OnConsoleStatusListener" />  
    
      ... the rest of the configuration file  
    </configuration>
    复制代码
```
2.3 property标签
--------------

属性 name , value 用来定义变量的 名称 和值 ，在上下文中可以通过 ${name} 的方式进行调用
```xml
    <configuration>
    
      <property name="USER_HOME" value="/home/sebastien" />
    
      <appender name="FILE" class="ch.qos.logback.core.FileAppender">
        <file>${USER_HOME}/myApp.log</file>
        <encoder>
          <pattern>%msg%n</pattern>
        </encoder>
      </appender>
    
      <root level="debug">
        <appender-ref ref="FILE" />
      </root>
    </configuration>
    复制代码
```
如果 定义如下示例会去 variables1.properties 中读取配置信息
```xml
    <configuration>
    
      <property file="src/main/java/chapters/configuration/variables1.properties" />
    
      <appender name="FILE" class="ch.qos.logback.core.FileAppender">
         <file>${USER_HOME}/myApp.log</file>
         <encoder>
           <pattern>%msg%n</pattern>
         </encoder>
       </appender>
    
       <root level="debug">
         <appender-ref ref="FILE" />
       </root>
    </configuration>


variables1.properties：

    USER_HOME=/home/sebastien
    复制代码
```
2.4appender标签
-------------

`appender` 为configuration 的子元素，每个 `appender` 都是一个日志组件， 可以定义一种类型的日志；

*   `name` ：appender 的名称，该值主要用于 `ref`。
*   `class`：定义appender 组件。
*   `scope`：指定作用域 ； `LOCAL`, `CONTEXT`,`SYSTEM`

如下示例 ： 定义2 个组件， 一个是文件存储，一个控制输出，通过 root 标签引用即可同时生效；
```xml
    <configuration>
    
      <appender name="FILE" class="ch.qos.logback.core.FileAppender">
        <file>myApp.log</file>
    
        <encoder>
          <pattern>%date %level [%thread] %logger{10} [%file:%line] %msg%n</pattern>
        </encoder>
      </appender>
    
      <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
          <pattern>%msg%n</pattern>
        </encoder>
      </appender>
    
      <root level="debug">
        <appender-ref ref="FILE" />
        <appender-ref ref="STDOUT" />
      </root>
    </configuration>
```

2.5contextName标签
----------------
```xml
`contextName`configuration 的子元素。每一个logger 都可以绑定一个`contextName`，默认上下文名称为 default ， 如果设定完成，则不能改变;

    <configuration>
      <contextName>myAppName</contextName>
      <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
          <pattern>%d %contextName [%t] %level %logger{36} - %msg%n</pattern>
        </encoder>
      </appender>
    
      <root level="debug">
        <appender-ref ref="STDOUT" />
      </root>
    </configuration>
```

2.6 logger标签
------------

用来设置某个包或及具体的某个类的日志输出以及指定 `<appender>`; name 属性一个， level，addtivity（是否向上级loger传递打印信息） 属性可选

如下所示，不想看见包chapters.configuration 中的debug级别日志，可以进行如下配置
```xml
    <configuration>
    
      <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <!-- encoders are assigned the type
             ch.qos.logback.classic.encoder.PatternLayoutEncoder by default -->
        <encoder>
          <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
      </appender>
    
      <logger name="chapters.configuration" level="INFO"/>
    
      <!-- Strictly speaking, the level attribute is not necessary since -->
      <!-- the level of the root level is set to DEBUG by default.       -->
      <root level="DEBUG">          
        <appender-ref ref="STDOUT" />
      </root>  
      
    </configuration>
```

打印如下

    17:34:07.578 [main] INFO  chapters.configuration.MyApp3 - Entering application.
    17:34:07.578 [main] INFO  chapters.configuration.MyApp3 - Exiting application.
    复制代码

2.7 root 标签
-----------

root标签实质是`<logger>`标签，不过其是根标签；若 `<logger >` 或 `<appender>` 标签为设置输出级别时就会默认继承该标签设置的级别！
```xml
    <!-- 日志输出级别 -->
    	<root level="INFO">
    		<appender-ref ref="STDOUT" />
    		<appender-ref ref="FILE" />
    	</root>
```

2.8 include标签
-------------

包含其它文件的配置信息
```xml
    <configuration>
      <include file="src/main/java/chapters/configuration/includedConfig.xml"/>
    
      <root level="DEBUG">
        <appender-ref ref="includedConsole" />
      </root>
    
    </configuration>
```

includedConfig.xml 示例，必须包含`<included>`标签
```xml
    <included>
      <appender name="includedConsole" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
          <pattern>"%d - %m%n"</pattern>
        </encoder>
      </appender>
    </included>
```

如过是URL

    <include url="http://some.host.com/includedConfig.xml"/>
    复制代码

三 多环境配置
=======

为了支持 development, testing 和 production 多环境下logback 不冲突的问题，可以使用 `<if>` , `then` 进行配置，使目标环境生效；

格式如下
```xml
     <!-- if-then form -->
       <if condition="some conditional expression">
        <then>
          ...
        </then>
      </if>
      
      <!-- if-then-else form -->
      <if condition="some conditional expression">
        <then>
          ...
        </then>
        <else>
          ...
        </else>    
      </if>
```

四 示例
====

4.1正常日志appender示例
-----------------
```xml
    <!-- 日志 appender ： 按照每天生成日志文件 -->
    <appender name="NORMAL-FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <append>true</append>
        <!-- 日志名称 -->
        <file>${logging.path}/zszxz-boot/zszxz-error.log</file>
        <!-- 每天生成一个日志文件，保存30天的日志文件 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!--日志文件输出的文件名:按天回滚 daily -->
            <FileNamePattern>${logging.path}/zszxz-boot/zszxz.log.%d{yyyy-MM-dd}</FileNamePattern>
            <!--日志文件保留天数-->
            <MaxHistory>30</MaxHistory>
        </rollingPolicy>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <!--格式化输出：%d表示日期，%thread表示线程名，%-5level：级别从左显示5个字符宽度%msg：日志消息，%n是换行符-->
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
            <!-- 编码 -->
            <charset>UTF-8</charset>
        </encoder>
    </appender>
```

4.2错误日志appender示例
-----------------
```xml
    <!-- 错误日志 appender ： 按照每天生成日志文件 -->
    <appender name="ERROR-FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <append>true</append>
        <!-- 过滤器，只记录 error 级别的日志 -->
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>error</level>
        </filter>
        <!-- 日志名称 -->
        <file>${logging.path}/zszxz-boot/zszxz-error.log</file>
        <!-- 每天生成一个日志文件，保存30天的日志文件 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!--日志文件输出的文件名:按天回滚 daily -->
            <FileNamePattern>${logging.path}/zszxz-boot/zszxz-error.log.%d{yyyy-MM-dd}</FileNamePattern>
            <!--日志文件保留天数-->
            <MaxHistory>30</MaxHistory>
        </rollingPolicy>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <!--格式化输出：%d表示日期，%thread表示线程名，%-5level：级别从左显示5个字符宽度%msg：日志消息，%n是换行符-->
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
            <!-- 编码 -->
            <charset>UTF-8</charset>
        </encoder>
    </appender>
```

五 官方文档
======

更多的日志配置内容请参照官方文档

[logback.qos.ch/manual/inde…](http://logback.qos.ch/manual/index.html)
