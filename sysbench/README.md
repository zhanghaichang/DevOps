# sysbench
> sysbench是一个开源的、模块化的、跨平台的多线程性能测试工具，可以用来进行CPU、内存、磁盘I/O、线程、数据库的性能测试。目前支持的数据库有MySQL、Oracle和PostgreSQL。以下操作都将以支持MySQL数据库为例进行。

### Installing from Binary Packages

**RHEL/CentOS:**

```
curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.rpm.sh | sudo bash
sudo yum -y install sysbench
```

**Build Requirements**

```
yum -y install make automake libtool pkgconfig libaio-devel
# For MySQL support, replace with mysql-devel on RHEL/CentOS 5
yum -y install mariadb-devel openssl-devel
# For PostgreSQL support
yum -y install postgresql-devel
```

**Build and Install**

```
./autogen.sh
# Add --with-pgsql to build with PostgreSQL support
./configure
make -j
make install
```

**安装成功**

```
[root@test sysbench-1.0]# sysbench --version
sysbench 1.0.9
```

# OLTP测试

>  oltp是针对数据库的基准测试，例如每次对数据库进行优化后执行基准测试来测试不同的配置的tps。sysbench 0.5之后通过一系列LUA脚本来替换之前的oltp，来模拟更接近真实的基准测试环境。这些测试脚本包含：insert.lua、oltp.lua、parallel_prepare.lua、select_random_points.lua、update_index.lua、delete.lua oltp_simple.lua、select.lua、select_random_ranges.lua、update_non_index.lua

```
预置条件：
a)创建数据库：
mysqladmin create sbtest -uroot –p
或者
SQL>create database sbtest
b)增加权限：
grant usage on . to 'sbtest'@'%' identified by password '*2AFD99E79E4AA23DE141540F4179F64FFB3AC521';
其中密码通过如下命令获取：
select password('sbtest');
+-------------------------------------------+
| password('sbtest') |
+-------------------------------------------+
| 2AFD99E79E4AA23DE141540F4179F64FFB3AC521 |
+-------------------------------------------+
1 row in set (0.00 sec)
c)增加权限：
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,INDEX ON sbtest.TO 'sbtest'@"%";
grant all privileges on . to 'sbtest'@'%';
flush privileges;
或者简单粗暴：
create user 'sbtest'@'127.0.0.1' identified by 'sbtest';
grant all privileges on . to
flush privileges;
e)OLTP测试：
准备阶段：
sysbench --test= /usr/local/share/sysbench/tests/include/oltp_legacy/oltp.lua --oltp-table-size=10000 --mysql-table-engine=innodb --oltp-tables-count=10 --mysql-user=sbtest --mysql-password=sbtest --mysql-port=3306 --mysql-host=127.0.0.1 --max-requests=0 --time=10 --report-interval=1 --threads=10 --oltp-point-selects=1 --oltp-simple-ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=0 --oltp_distinct_ranges=0 --oltp-read-only=on prepare
测试阶段：
命令如下：
sysbench --test= /usr/local/share/sysbench/tests/include/oltp_legacy/oltp.lua --oltp-table-size=10000 --mysql-table-engine=innodb --oltp-tables-count=10 --mysql-user=sbtest --mysql-password=sbtest --mysql-port=3306 --mysql-host=127.0.0.1 --max-requests=0 --time=10 --report-interval=1 --threads=10 --oltp-point-selects=1 --oltp-simple-ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=0 --oltp_distinct_ranges=0 --oltp-read-only=on run
清理阶段：
sysbench --test= /usr/local/share/sysbench/tests/include/oltp_legacy/oltp.lua --oltp-table-size=10000 --mysql-table-engine=innodb --oltp-tables-count=10 --mysql-user=sbtest --mysql-password=sbtest --mysql-port=3306 --mysql-host=127.0.0.1 --max-requests=0 --time=10 --report-interval=1 --threads=10 --oltp-point-selects=1 --oltp-simple-ranges=0 --oltp_sum_ranges=0 --oltp_order_ranges=0 --oltp_distinct_ranges=0 --oltp-read-only=on cleanup
最后删除数据库
SQL>drop database sbtest;
```
**准备数据**

```
sysbench ./tests/include/oltp_legacy/oltp.lua --mysql-host=192.168.10.10 --mysql-port=3306 --mysql-user=root --mysql-password=123456 --oltp-test-mode=complex --oltp-tables-count=10 --oltp-table-size=100000 --threads=10 --time=120 --report-interval=10 prepare
```
其中，执行模式为complex，使用了10个表，每个表有10万条数据，客户端的并发线程数为10，执行时间为120秒，每10秒生成一次报告。

**执行测试**   

将测试结果导出到文件中，便于后续分析
```
sysbench ./tests/include/oltp_legacy/oltp.lua --mysql-host=192.168.10.10 --mysql-port=3306 --mysql-user=root --mysql-password=123456 --oltp-test-mode=complex --oltp-tables-count=10 --oltp-table-size=100000 --threads=10 --time=120 --report-interval=10 run >> /home/test/mysysbench.log
```
**清理数据**  

执行完测试后，清理数据，否则后面的测试会受到影响。
```
sysbench ./tests/include/oltp_legacy/oltp.lua --mysql-host=192.168.10.10 --mysql-port=3306 --mysql-user=root --mysql-password=123456 cleanup
```

**开始测试**

```
shell> sysbench --test=oltp --oltp_tables_count=10 --oltp-table-size=100000 --mysql-user=root --mysql-password=123456 --num-threads=20 --max-time=120 --max-requests=0 --oltp-test-mode=complex run >> /tmp/log/sysbench_oltpx_20161121.log

#执行结束后查看测试报告
shell> less /tmp/log/sysbench_oltpx_20161121.log
sysbench 1.0:  multi-threaded system evaluation benchmark

#报告内容如下:
Running the test with following options:
Number of threads: 20
Initializing random number generator from current time


Initializing worker threads...

Threads started!

OLTP test statistics:
    queries performed:
        read:                            935592 --读总数
        write:                           267295 --写总数
        other:                           133650 --其他操作(CURD之外的操作，例如COMMIT)
        total:                           1336537 --全部总数
    transactions:                        66822  (556.77 per sec.) --总事务数(每秒事务数)
    read/write requests:                 1202887 (10022.55 per sec.) --读写总数(每秒读写次数)
    other operations:                    133650 (1113.58 per sec.)  --其他操作总数(每秒其他操作次数)
    ignored errors:                      6      (0.05 per sec.)  --总忽略错误总数(每秒忽略错误次数)
    reconnects:                          0      (0.00 per sec.) --重连总数(每秒重连次数)

General statistics: --常规统计
    total time:                          120.0180s --总耗时
    total number of events:              66822 --共发生多少事务数
    total time taken by event execution: 2399.7900s  --所有事务耗时相加(不考虑并行因素)
    response time:
         min:                                  2.76ms --最小耗时
         avg:                                 35.91ms --平均耗时
         max:                               1435.19ms --最长耗时
         approx.  95 percentile:              84.22ms --超过95%平均耗时

Threads fairness: --并发统计
    events (avg/stddev):           3341.1000/37.54 --总处理事件数/标准偏差
    execution time (avg/stddev):   119.9895/0.02
--总执行时间/标准偏差
```
