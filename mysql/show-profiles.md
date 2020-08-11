# show profiles-- SQL语句资源消耗分析
> 是MySQL提供可以用来分析当前会话中SQL语句执行的资源消耗情况。可以用于SQL的调优测量。默认情况下，参数处于关闭状态，并保存最近 15 次的运行结果

* 查看是否开启

```
show variables like "%profiling%";
```

* 开启

```
set profiling = 1;
```

### 开始分析
* 先执行要分析的SQL语句
* 执行show profiles;会出现如下结果

### show profile返回结果字段含义

* Status ：sql 语句执行的状态
* Duration: sql 执行过程中每一个步骤的耗时
* CPU_user: 当前用户占有的 cpu
* CPU_system: 系统占有的 cpu
* Block_ops_in : I/O 输入
* Block_ops_out : I/O 输出

### show profile type 选项

* all：显示所有的性能开销信息
* block io：显示块 IO 相关的开销信息
* context switches: 上下文切换相关开销
* cpu：显示 CPU 相关的信息
* ipc：显示发送和接收相关的开销信息
* memory：显示内存相关的开销信息
* page faults：显示页面错误相关开销信息
* source：显示和 Source_function、Source_file、Source_line 相关的开销信息
* swaps：显示交换次数的相关信息

### status出现以下情况的建议

* System lock
> 确认是由于哪个锁引起的，通常是因为MySQL或InnoDB内核级的锁引起的。建议：如果耗时较大再关注即可，一般情况下都还好

* Sending data
> 解释：从server端发送数据到客户端，也有可能是接收存储引擎层返回的数据，再发送给客户端，数据量很大时尤其经常能看见。备注：Sending Data不是网络发送，是从硬盘读取，发送到网络是Writing to net。建议：通过索引或加上LIMIT，减少需要扫描并且发送给客户端的数据量


https://mp.weixin.qq.com/s?__biz=MzU0NDA2MjY5Ng==&mid=2247485173&idx=1&sn=cfbddaa71d8a33e74e9cd876a3fe5f92&scene=19#wechat_redirect
