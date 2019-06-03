
1.启动服务：
-------

#### 启动：

    sudo service influxdb start
    

#### 重启：

    service influxdb restart
    

2.在Linux中如何使用：
--------------

#### 进入influxDB，输入命令：

    influx
    

#### 查看InfluxDB状态：

    SHOW STATS
    

#### 创建一个数据库：

    create database "db_name"
    

#### 显示所有的数据库

    show databases 
    

#### 删除数据库

注：不区分大小写，会删除掉所有大小写不同，但名字相同的库

    drop database "db_name" 
    

#### 使用数据库

    use db_name 
    

#### 查看该数据库下所有表

    show measurements 
    

#### 创建表

注：直接在插入数据的时候指定表名,表自动创建，字段类型由传入的值决定。

    insert test,host=127.0.0.1,monitor_name=test count=1 
    

#### 删除表

    drop measurement measurement_name
    

#### 查询表

    select * from database limit 10
    

### 添加条件：

注：条件中的字符串需要用单引号包裹

    SELECT field1,field2 FROM "tableName"   WHERE time > '2018-08-15T02:29:20Z' AND time < '2018-08-15T02:30:20Z' Order by time DESC
    

#### 查看series

    show series from weather
    

#### 创建保存策略：

注：保存策略即存储在数据库中的数据，多长时间删除一次。

    create retention policy  "2_hours" on test_db duration 2h replication 1 default
    

解释：在数据`test_db`，添加了一个名字叫做 `2_hours`，`duration`为2小时，副本为1，并将其设置为默认策略。采用默认策略的表，将会执行相关配置。

修改完默认策略后，所有不是以“2_hours"为保留策略的表，都将不能直接查询，需要在表名`measurement`前，加上策略名，如：

    select * from "defalut".weather
    

#### 查看保存策略

show retention policies on test_db（数据库名）

### 修改保留策略：

    ALTER  retention policy "default" on test_db DEFAULT（修改默认）
    

或者在关键字上加引号也可以：

    ALTER  retention policy "default" on "test_db" duration 719h
    

### 删除保留策略：

    drop retention policy xxxName  on test_db
    

3.在浏览器中如何使用
-----------

InfluxDB默认是通过Http请求访问数据库的，也支持UDP协议（默认关闭），所以可以通过浏览器直接查询或新增删除数据。

    格式：数据库地址 + 端口 + query?db = 数据库名&q = 查询或删除或插入的SQL语句
    

**举例：**

    http://10.10.1.2:8086/query?db=testdb&q=select * from measurement limit 10
