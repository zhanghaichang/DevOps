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
