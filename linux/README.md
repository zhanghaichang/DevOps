
## 远程复制

```
scp -r  server-jre-8u191-linux-x64.tar.gz zhanghc@172.18.161.168:/data/java/
```
## Linux中查看各文件夹大小命令
```
du -h --max-depth=1
```

## 测试UDP端口
```
yum -y install nv
nc -vuz IP port
```

## 查看端口

```
ss -tanls

# 查看端口被谁占用

netstat -tunlp|grep 端口号
```
## 查看系统版本

**1.Linux查看当前操作系统版本信息**  

> cat /proc/version

**2.Linux查看版本当前操作系统内核信息**

> uname -a

**3.linux查看版本当前操作系统发行信息**

> cat /etc/issue 或 cat /etc/centos-release


**4.Linux查看cpu相关信息，包括型号、主频、内核信息等**

> cat /proc/cpuinfo

```
CPU配置信息：
frank@ubuntu:~/test/python$ cat /proc/cpuinfo
    processor       : 0                                                #系统中逻辑处理核的编号
    vendor_id       : GenuineIntel                                    #CPU制造商
    cpu family      : 6                                                #CPU产品系列代号
    model           : 79                                            #CPU属于其系列中的哪一代的代号
    model name      : Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz        #CPU属于的名字及其编号、标称主频
    stepping        : 1                                                #CPU属于制作更新版本
    microcode       : 0xb00001f
    cpu MHz         : 2199.900                                        #CPU的实际使用主频
    cache size      : 25600 KB                                        #CPU二级缓存大小
    physical id     : 0                                                #单个CPU的标号
    siblings        : 20                                            #一个物理CPU中的逻辑核数
    core id         : 0                                                #当前物理核在其所处CPU中的编号，这个编号不一定连续
    cpu cores       : 10                                            #一个物理CPU中的物理核数
    apicid          : 0                                                #用来区分不同逻辑核的编号，系统中每个逻辑核的此编号必然不同，此编号不一定连续
    initial apicid  : 0
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 20
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm rdseed adx smap
    bogomips        : 4399.80
    clflush size    : 64
    cache_alignment : 64
    address sizes   : 46 bits physical, 48 bits virtual
    power management:

物理CPU个数：        cat /proc/cpuinfo |grep "physical id"|sort |uniq|wc -l
每个CPU物理核数：    cat /proc/cpuinfo |grep "cpu cores"|uniq
每个CPU逻辑核数：    cat /proc/cpuinfo |grep "siblings"|uniq
总CPU逻辑核数：        cat /proc/cpuinfo |grep -c "processor"
我的服务器是两个芯片组，每个芯片组是10核，支持超线程，所以逻辑CPU是40。
超线程指物理内核+逻辑内核，芯片上只存在一个物理内核，但是这个物理内核可以模拟出一个逻辑内核，于是系统信息就显示了两个内核，一真一假。
```

**1.查看系统版本信息的命令**

> lsb_release -a 

**2.查看centos版本号**

> cat /etc/issue


## 文件句柄数

### 查看线程占句柄数

```
ulimit -a

输出如下：
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 59367
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 59367
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited

其中：
open files                      (-n) 1024         代表每个

```

### 查看系统打开句柄最大数量

```
more /proc/sys/fs/file-max
```
### 查看打开句柄总数

```
lsof|awk '{print $2}'|wc -l
```
根据打开文件句柄的数量降序排列，其中第二列为进程ID：
```
lsof|awk '{print $2}'|sort|uniq -c|sort -nr|more
```
根据获取的进程ID查看进程的详情

```
ps -ef |grep XXXXX
```
### 修改linux单进程最大文件连接数

修改linux系统参数。vi /etc/security/limits.conf 添加
```
*　　soft　　nofile　　65536
*　　hard　　nofile　　65536
```
修改以后保存，注销当前用户，重新登录，执行ulimit -a ,ok ,参数生效了：
