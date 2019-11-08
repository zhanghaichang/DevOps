# DRUID 配置

```yaml
spring:
  datasource:
    # druid连接池
    type: com.alibaba.druid.pool.DruidDataSource
    #数据库驱动
    driver: com.mysql.jdbc.Driver
    #最大连接池数量
    max-active: 20
    #初始化时建立物理连接的个数。初始化发生在显示调用init方法，或者第一次getConnection时
    initial-size: 10
    # 获取连接时最大等待时间，单位毫秒。配置了maxWait之后，缺省启用公平锁，
    # 并发效率会有所下降，如果需要可以通过配置useUnfairLock属性为true使用非公平锁。
    max-wait: 60000
    #最小连接池数量
    min-idle: 5
    #有两个含义：
    #1: Destroy线程会检测连接的间隔时间
    #2: testWhileIdle的判断依据，详细看testWhileIdle属性的说明
    time-between-eviction-runs-millis: 60000
    #配置一个连接在池中最小生存的时间，单位是毫秒
    min-evictable-idle-time-millis: 180000
    #用来检测连接是否有效的sql，要求是一个查询语句。如果validationQuery为null，testOnBorrow、testOnReturn、testWhileIdle都不会其作用。
    validation-query: select 'x'
    #连接有效性检查的超时时间 1 秒
    validation-query-timeout: 1
    #申请连接时执行validationQuery检测连接是否有效，做了这个配置会降低性能。
    test-on-borrow: false
    #设置从连接池获取连接时是否检查连接有效性，true时，如果连接空闲时间超过minEvictableIdleTimeMillis进行检查，否则不检查;false时，不检查
    test-while-idle: true
    #归还连接时执行validationQuery检测连接是否有效，做了这个配置会降低性能
    test-on-return: false
    #是否缓存preparedStatement，也就是PSCache。PSCache对支持游标的数据库性能提升巨大，比如说oracle。在mysql下建议关闭。
    pool-prepared-statements: true
    #要启用PSCache，必须配置大于0，当大于0时，poolPreparedStatements自动触发修改为true。在Druid中，
    # 不会存在Oracle下PSCache占用内存过多的问题，可以把这个数值配置大一些，比如说100
    max-open-prepared-statements: 20
    #数据库链接超过3分钟开始关闭空闲连接 秒为单位
    remove-abandoned-timeout: 1800
    #对于长时间不使用的连接强制关闭
    remove-abandoned: true
    #打开后，增强timeBetweenEvictionRunsMillis的周期性连接检查，minIdle内的空闲连接，
    # 每次检查强制验证连接有效性. 参考：https://github.com/alibaba/druid/wiki/KeepAlive_cn
    keep-alive: true
    # 通过connectProperties属性来打开mergeSql功能；慢SQL记录
    connect-properties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=5000
    #是否超时关闭连接 默认为false ,若为true 就算数据库恢复连接，也无法连接上
    break-after-acquire-failure: false
    #设置获取连接出错时的自动重连次数
    connection-error-retry-attempts: 1
    #设置获取连接时的重试次数，-1为不重试
    not-full-fimeout-retry-count: 2
    #重连间隔时间 单位毫秒
    acquire-retry-delay: 10000
    # 设置获取连接出错时是否马上返回错误，true为马上返回
    fail-fast: true
    #属性类型是字符串，通过别名的方式配置扩展插件，常用的插件有：
    #监控统计用的filter:stat日志用的filter:log4j防御sql注入的filter:wall
    filters: stat,wall
```

自己在工作中 总结的的 druid 配置算是比较全的了，为了 解决 数据连接超时 向前台提示 服务器超时信息 几乎逛了 整个 druid配置文件

问题原因：当出现网络原因时，druid 会不对发送请求，试图连接数据库，就会造成sockt 阻塞。

解决原因：百度，看源码（一点注释都没用，靠猜的），重新配置 DruidDataSource

经过不懈努力，面向百度编程的功底深厚，也解决此问题。

注意：后台任然会不断尝试连接数据库，能解决(在配置中)，但是不介意，也许会造成恢复网络后依然连接上。


感谢 以下 大佬提供的数据，

https://blog.csdn.net/Swollow_/article/details/83624585 特别感谢

https://www.jianshu.com/p/d7323afab808 特别感谢

http://www.iigrowing.cn/?p=7551

https://www.cnblogs.com/jianzhixuan/p/6923216.html

https://blog.csdn.net/qq_34359363/article/details/72763491?locationNum=3&fps=1
