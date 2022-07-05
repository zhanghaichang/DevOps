# vmware下 RHEL 6.4+ASM+oracle11gRAC安装

## 1、ip地址规划

```shell
type
ip address
interface
node1
public-ip
192.168.250.6
eth0

virtual-ip
192.168.250.8
eth0:1

priv-ip
10.0.1.108
eth1
node2
public-ip
192.168.250.7
eth0

virtual-ip
192.168.250.9
eth0:1

priv-ip
10.0.1.109
eth1
scan-cluster
scan-ip
192.168.250.55
eth0
```

## 2、配置主机IP地址，修改hosts文件

```shell
[root@db1 ~]# vi /etc/hosts
127.0.0.1   localhost
::1          localhost6.localdomain6 localhost6
#Public Network
192.46.2.51 db1
192.46.2.52 db2
#Private Interconnect
10.0.1.106 db1-priv
10.0.1.107 db2-priv
#Public Virtual ip
192.46.2.71 db1-vip
192.46.2.72 db2-vip
192.46.2.73 rac-scan.com rac-scan

-----网卡，分别配置两个节点-----
[root@db1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
DEVICE=eth0
HWADDR=00:50:56:AD:5B:9F
ONBOOT=yes
BOOTPROTO=static
IPADDR=192.168.250.6
NETMASK=255.255.255.0
GATEWAY=192.168.250.254

[root@db1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
HWADDR=00:50:56:AD:76:0C
ONBOOT=yes
IPADDR=10.0.1.108
NETMASK=255.255.255.0
```

## 3、创建数据库用户

```shell
[root@db1 etc]# groupadd -g 1000 oinstall
[root@db1 etc]# groupadd -g 1200 asmadmin
[root@db1 etc]# groupadd -g 1201 asmdba
[root@db1 etc]# groupadd -g 1202 asmoper
[root@db1 etc]# useradd -m -u 1100 -g oinstall -G asmadmin,asmdba,asmoper -d /home/grid -s /bin/bash -c "Grid Infrastructure Owner" grid
[root@db1 etc]# id grid
uid=1100(grid) gid=1000(oinstall) groups=1000(oinstall),1200(asmadmin),1201(asmdba),1202(asmoper) context=root:system_r:unconfined_t:SystemLow-SystemHigh

[root@db1 etc]# groupadd -g 1300 dba
[root@db1 etc]# groupadd -g 1301 oper
[root@db1 etc]# useradd -m -u 1101 -g oinstall -G dba,oper,asmdba -d /home/oracle -s /bin/bash -c "Oracle Software Owner" oracle
[root@db1 etc]# id oracle
uid=1101(oracle) gid=1000(oinstall) groups=1000(oinstall),1201(asmdba),1300(dba),1301(oper) context=root:system_r:unconfined_t:SystemLow-SystemHig

[root@db1 etc]passwd oracle
[root@db1 etc]passwd grid

验证nobody用户存在：id nobody，如果输出了用户的信息，则用户存在，如果用户不存在，则使用以下语句创建用户：
[root@db1 etc]#/usr/sbin/useradd nobody
```

## 4、在所有节点创建安装目录

```shell
[root@db2 ~]# mkdir -p /u01/app/grid
[root@db2 ~]# mkdir -p /u01/app/11.2.0/grid
[root@db2 ~]# chown -R grid:oinstall /u01

[root@db2 ~]# mkdir -p /u01/app/oracle
[root@db2 ~]# chown -R oracle:oinstall /u01/app/oracle
[root@db2 ~]# chmod -R 755 /u01

/u01/app/oracle 是oracle的ORACLE_BASE目录
/u01/app/grid 是grid的ORACLE_BASE目录
/u01/app/11.2.0/grid是grid的ORACLE_HOME目录
说明：grid在安装的时候ORACLE_HOME不能是ORACLE_BASE的子目录，所以要新建立一个目录存放grid的ORACLE_HOME
```

## 5、修改oracle和grid的.bash_profile文件

```shell
su - grid
vi .bash_profile

export ORACLE_SID=+ASM1
export ORACLE_BASE=/u01/app/grid
export ORACLE_HOME=/u01/app/11.2.0/grid
JAVA_HOME=/usr/local/java; export JAVA_HOME
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
NLS_LANG=AMERICAN_AMERICA.ZHS16GBK; export NLS_LANG
ORACLE_PATH=/u01/app/oracle/common/oracle/sql; export ORACLE_PATH
ORACLE_TERM=xterm; export ORACLE_TERM
NLS_DATE_FORMAT="DD-MON-YYYY HH24:MI:SS"; export NLS_DATE_FORMAT
TNS_ADMIN=$ORACLE_HOME/network/admin; export TNS_ADMIN
ORA_NLS11=$ORACLE_HOME/nls/data; export ORA_NLS11
PATH=.:${JAVA_HOME}/bin:${PATH}:$HOME/bin:$ORACLE_HOME/bin
PATH=${PATH}:/usr/bin:/bin:/usr/bin/X11:/usr/local/bin
PATH=${PATH}:/u01/app/common/oracle/bin
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$ORACLE_HOME/oracm/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/lib:/usr/lib:/usr/local/lib
export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/rdbms/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/network/jlib
export CLASSPATH
THREADS_FLAG=native; export THREADS_FLAG
export TEMP=/tmp
export TMPDIR=/tmp
export PS1="`/usr/bin/hostname`-> " ---环境变量提示符

su - oracle
vi .bash_profile

ORACLE_SID=jgpt(建库时与此实例名相同); export ORACLE_SID
ORACLE_UNQNAME=racdb; export ORACLE_UNQNAME
JAVA_HOME=/usr/local/java; export JAVA_HOME
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1; export ORACLE_HOME
ORACLE_PATH=/u01/app/common/oracle/sql; export ORACLE_PATH
ORACLE_TERM=xterm; export ORACLE_TERM
NLS_DATE_FORMAT="DD-MON-YYYY HH24:MI:SS"; export NLS_DATE_FORMAT
TNS_ADMIN=$ORACLE_HOME/network/admin; export TNS_ADMIN
ORA_NLS11=$ORACLE_HOME/nls/data; export ORA_NLS11
PATH=.:${JAVA_HOME}/bin:${PATH}:$HOME/bin:$ORACLE_HOME/bin
PATH=${PATH}:/usr/bin:/bin:/usr/bin/X11:/usr/local/bin
PATH=${PATH}:/u01/app/common/oracle/bin
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$ORACLE_HOME/oracm/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/lib:/usr/lib:/usr/local/lib
export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/rdbms/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/network/jlib
export CLASSPATH
THREADS_FLAG=native; export THREADS_FLAG
export TEMP=/tmp
export TMPDIR=/tmp
# ---------------------------------------------------
# UMASK
# ---------------------------------------------------
# Set the default file mode creation mask
# (umask) to 022 to ensure that the user performing
# the Oracle software installation creates files
# with 644 permissions.
# ---------------------------------------------------
umask 022
```

## 6、修改系统参数

```shell
vi /etc/security/limits.conf
尾部增加以下文件
# add by zhengye
grid soft nproc 2047
grid hard nproc 16384
grid soft nofile 1024
grid hard nofile 65536
grid soft stack 10240
grid hard stack 32768
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
oracle soft stack 10240
oracle hard stack 32768

vi /etc/pam.d/login
尾部增加以下文件
session    required     pam_limits.so

vi /etc/profile
if [ /$USER = "oracle" ] || [ /$USER = "grid" ]; then
    if [ /$SHELL = "/bin/ksh" ]; then
        ulimit -p 16384
        ulimit -n 65536
    else
        ulimit -u 16384 -n 65536
    fi
    umask 022
fi

vi /etc/sysctl.conf

# Controls the maximum number of shared memory segments, in pages
kernel.shmall = 4294967296
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
fs.file-max = 6815744
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 2097152
#add by zhengye
vm.nr_hugepages = 25606

sysctl -p 使参数生效
```

## 7、同步时间

```shell
使用集群时间同步服务在集群中提供同步服务，需要卸载网络时间协议 (NTP) 及其配置。
要停用 NTP 服务，必须停止当前的 ntpd 服务，从初始化序列中禁用该服务，并删除 ntp.conf 文件。要在 Oracle Enterprise Linux 上完成这些步骤，以 root 用户身份在两个 Oracle RAC 节点上运行以下命令：
[root@db1 ~]# /sbin/service ntpd stop
[root@db1 ~]# chkconfig ntpd off
[root@db1 ~]# mv /etc/ntp.conf /etc/ntp.conf.original

还要删除以下文件：
[root@db1 ~]# rm /var/run/ntpd.pid
此文件保存了 NTP 后台程序的 pid。
```

## 8、配置用户等效性

```shell
用户的等效性不需要配置 oracle11g安装grid会自动配置等效性。
这里注意原来10g安装rac只需要配置oracle用户等效性就可以了，11g的rac还需要配置grid用户的等效性，grid用户配置与oracle用户配置同理，这里只给出oracle用户等效性配置

在db1:
[oracle@db1 ~]$ mkdir ~/.ssh
[oracle@db1 ~]$ chmod 700 ~/.ssh
[oracle@db1 ~]$ ssh-keygen -t rsa
[oracle@db1 ~]$ ssh-keygen -t dsa

在db2：
[oracle@db2 ~]$ mkdir ~/.ssh
[oracle@db2 ~]$ chmod 700 ~/.ssh
[oracle@db2 ~]$ ssh-keygen -t rsa
[oracle@db2 ~]$ ssh-keygen -t dsa

切换回db1，接着执行：
[oracle@db1 ~]$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
[oracle@db1 ~]$ cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys

提示：下列命令会提示你输入bjgtj2 的oracle 密码，按照提示输入即可，如果失败可重新尝试执行命令。
db1 节点：
[oracle@db1 ~]$ scp ~/.ssh/authorized_keys db2:~/.ssh/authorized_keys

db2节点：
[oracle@db2 ~]$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
[oracle@db2 ~]$ cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
[oracle@db2 ~]$  scp ~/.ssh/authorized_keys db1:~/.ssh/authorized_keys

确保2个node都有相互的结点信息。两机相互执行。
[oracle@db1 ~]$ ssh db1 date
[oracle@db1~]$ ssh db2 date
[oracle@db1 ~]$ ssh db1-priv date
[oracle@db1 ~]$ ssh db2-priv date

切换至db2 执行
[oracle@db2 ~]$ ssh db1 date
[oracle@db2~]$ ssh db2 date
[oracle@db2 ~]$ ssh db1-priv date
[oracle@db2 ~]$ ssh db2-priv date
```

## 9、添加共享磁盘，安装ASM并创建ASM磁盘

```shell
机器原有的磁盘是sda，已经分区后使用。这里用vmware新添加了一块30GB的共享磁盘sdb ,RHEL 6以后oracle不在支持asmlib，我们这里采用udev磁盘绑定，防止linux操作系统重启，asm识别不到磁盘
---获取sdb磁盘的scsi磁盘scsi编号
[root@db1 ~]# scsi_id --whitelisted --replace-whitespace --device=/dev/sdb
36000c2968fb709c5bf21bd5ddafcba37
---编辑磁盘绑定文件，如果没有此文件，则创建文件
vi /etc/udev/rules.d/99-oracle-asmdevices.rules
KERNEL=="sd*",SUBSYSTEM=="block",PROGRAM=="/sbin/scsi_id scsi_id --whitelisted --replace-whitespace --device=/dev/$name",RESULT=="36
000c2968fb709c5bf21bd5ddafcba37",NAME="asm-disk1",OWNER="grid",GROUP="asmadmin",MODE="0660"
---启动udev服务
start_udev  或者重启机器
```

## 10、禁用iptables和SELINUX

```shell
---禁用防火墙
service iptables stop
chkconfig iptables off
---禁用SELINUX
cp /etc/selinux/config  /etc/selinux/config_bak
vi /etc/selinux/config
SELINUX=disabled
重启操作系统reboot

执行setenforce 0立即生效
```

## 11、安装操作系统包

```shell
配yum源，按照官网包规则安装，这里需要另外单独安装两个包，pdksh-5.2.14-1.i386.rpm 和 cvuqdisk-1.0.9-1.rpm
cvuqdisk-1.0.9-1.rpm包是用来发现asm共享磁盘，必须安装，这个包在grid软件解压后/soft/grid/rpm/目录

cloog-ppl 
compat-libcap1 
compat-libstdc++-33 
cpp 
gcc 
gcc-c++ 
glibc-devel 
glibc-headers 
kernel-headers 
ksh 
libXmu 
libXt 
libXv 
libXxf86dga 
libXxf86misc 
libXxf86vm 
libaio-devel 
libdmx 
libstdc++-devel 
mpfr 
make 
ppl 
xorg-x11-utils 
xorg-x11-xauth

compat-libstdc
elfutils-libelf

yum install -y cloog-ppl*
yum install -y compat-libcap1*
yum install -y compat-libstdc++-33*
yum install -y cpp*
yum install -y gcc*
yum install -y gcc-c++*
yum install -y glibc-devel*
yum install -y glibc-headers*
yum install -y kernel-headers*
yum install -y ksh*
yum install -y libXmu*
yum install -y libXt*
yum install -y libXv*
yum install -y libXxf86dga*
yum install -y libXxf86misc*
yum install -y libXxf86vm*
yum install -y libaio-devel*
yum install -y libdmx*
yum install -y libstdc++-devel*
yum install -y mpfr*
yum install -y make*
yum install -y ppl*
yum install -y xorg-x11-utils*
yum install -y xorg-x11-xauth*
yum install -y elfutils-libelf-devel*
```

## 12、安装CLuster软件

```shell
11g中用grid用户管理cluster，故用grid用户安装cluster软件，安装grid软件之前可以先检查安装环境，进入到grid的解压目录里，找到runcluvfy.sh，运行以下命令：
./runcluvfy.sh stage -pre crsinst -n db1,db2 -fixup -verbose    如果检查有failed的则修复，直到没有failed的进行下一步安装，依次选择的顺序如下：

install and  Configure Grid infrastructure for a Cluster
Advanced Installation
语言默认用English
将Configure GNS的勾去掉，输入Cluster Name和SCAN Name，这两处输入的名字可以按照你之前配置的/etc/hosts文件最后添加的内容 192.168.2.212 rac-scan.tianlesoftware.com   rac-scan
Cluster Name  rac-scan
SCAN Name   rac-scan.tianlesoftware.com
点击add增加节点2的信息，然后点击SSH Connectivity，输入密码后点击Setup，验证成功则进入下一步
网卡eth0和eth1这块直接下一步
存储方式选择ASM
输入Disk Group Name  : OCRVOTEDG，Redundancy选择External，这里先给ocr和votedisk选择ORCL：OCRVOTEDG然后下一步
Use same password for  these account，输入密码
Do not use intellgent Platform Management Interface(IPM)

当执行root.sh失败，使用root用户，用下面命令清空crs配置信息
perl /oracle/grid/11.2.0.4/crs/install/rootcrs.pl -verbose -deconfig -force

下面的命令是清空ocr和votingdisk配置
perl /oracle/grid/11.2.0.4/crs/install/rootcrs.pl -verbose -deconfig -force -lastnode
```

## 13、安装oracle软件

## 14、客户端tnsname.ora配置

```shell
HOST直接写scan IP地址
jgpt_scan =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.250.55)(PORT = 1521))
    (LOAD_BALANCE = yes)
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = jgpt)
    )
  )
```

## 15、asmca

创建数据库：图形界面下输入asmca创建数据库磁盘组（选择外部冗余extan。。。。。）



# ORACLE11G+ASM+RAC安装+AIX6.1

-----AIX6.1+ASM+oracle11gRAC安装----

---按照脚本安装aix软件包
---创建rootvg镜像
---创建oracle_lv以及u01文件系统
---扩展lg_dumplv
---同步时区smitty chtz_date

bos.adt.base
bos.adt.lib
bos.adt.libm
bos.perf.libperfstat
bos.perf.perfstat
bos.perf.proctools
rsct.basic.rte
rsct.compat.clients.rte
xlC.aix61.rte      10.1.0.0 or later
xlC.rte               10.1.0.0 or later

lslpp -l bos.adt.base bos.adt.lib bos.adt.libm bos.perf.libperfstat bos.perf.perfstat bos.perf.proctools rsct.basic.rte rsct.compat.clients.rte

## 1、ip地址规划

```SHELL
type
ip address
interface
caic1
public-ip
192.168.22.201
eth0

virtual-ip
192.168.22.203
eth0:1

priv-ip
11.0.1.108
eth1
caic2
public-ip
192.168.22.202
eth0

virtual-ip
192.168.22.204
eth0:1

priv-ip
11.0.1.109
eth1
scan-cluster
scan-ip
192.168.22.205
eth0
```



## 2、配置主机host文件

```SHELL
#Public Network
192.168.22.201 caic1
192.168.22.202 caic2
#Private Interconnect
11.0.1.108 caic1-priv
11.0.1.109 caic2-priv
#Public Virtual ip
192.168.22.203 caic1-vip
192.168.22.204 caic2-vip
#Scan IP
192.168.22.205 rac-scan
```

## 3、创建组和相应的用户

```SHELL
---创建组
mkgroup -'A' id='1000' adms='root' oinstall
mkgroup -'A' id='1100' adms='root' asmadmin
mkgroup -'A' id='1200' adms='root' dba
mkgroup -'A' id='1201' adms='root' oper
mkgroup -'A' id='1300' adms='root' asmdba
mkgroup -'A' id='1301' adms='root' asmoper
---创建用户
mkuser id='1100' pgrp='oinstall' groups='asmadmin,asmdba,asmoper' home='/home/grid' grid
mkuser id='1101' pgrp='oinstall' groups='dba,asmdba' home='/home/oracle' oracle

chuser  capabilities=CAP_NUMA_ATTACH,CAP_BYPASS_RAC_VMM,CAP_PROPAGATE grid
chuser  capabilities=CAP_NUMA_ATTACH,CAP_BYPASS_RAC_VMM,CAP_PROPAGATE oracle
```

## 4、配置用户环境变量

```SHELL
----oracle用户--------
export PS1="`/usr/bin/hostname`-> "
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/db_home
export ORACLE_OWNER=oracle
export ORACLE_SID=corcl1
export PATH=$PATH:$ORACLE_HOME/bin:$ORA_GRID_HOME/bin:$ORACLE_HOME/OPatch:$ORACLE_HOME/jdk/bin:/sbin:/usr/sbin:/bin:/usr/local/bin:.
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$ORACLE_HOME/rdbms/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib:$ORACLE_HOME/network/jlib
export NLS_LANG=american_america.ZHS16GBK
export ORACLE_PATH=/home/oracle

----grid用户----------
export PS1="`/usr/bin/hostname`-> "
export ORACLE_SID=+ASM1
export ORACLE_BASE=/u01/app/grid/grid_base
export ORACLE_HOME=/u01/app/grid/grid_home
export PATH=$ORACLE_HOME/bin:/u01/app/grid/grid_home/OPatch:$PATH:/usr/local/bin/:.

-----root用户---------
vi /etc/profile
export ORACLE_HOME=/u01/app/grid/grid_home
export PATH=$ORACLE_HOME/bin:$PATH:/usr/local/bin/
```

## 5、修改磁盘属性

```SHELL
 chdev -l hdisk4 -a reserve_policy=no_reserve
 chdev -l hdisk5 -a reserve_policy=no_reserve
 chdev -l hdisk6 -a reserve_policy=no_reserve
 chdev -l hdisk7 -a reserve_policy=no_reserve
 chdev -l hdisk8 -a reserve_policy=no_reserve
 chdev -l hdisk9 -a reserve_policy=no_reserve
------------------------------------
chown -R grid:oinstall /dev/rhdisk4
chown -R grid:oinstall /dev/rhdisk5
chown -R grid:oinstall /dev/rhdisk6
chown -R grid:oinstall /dev/rhdisk7
chown -R grid:oinstall /dev/rhdisk8
chown -R grid:oinstall /dev/rhdisk9
------------------------------------
 chmod -R 660 /dev/rhdisk4
 chmod -R 660 /dev/rhdisk5
 chmod -R 660 /dev/rhdisk6
 chmod -R 660 /dev/rhdisk7
 chmod -R 660 /dev/rhdisk8
 chmod -R 660 /dev/rhdisk9
```

## 6、修改网络参数

```SHELL
no -r -o rfc1323=1 
no -r -o sb_max=4194304
no -r -o tcp_recvspace=65536 
no -r -o tcp_sendspace=65536 
no -r -o udp_recvspace=655360 
no -r -o udp_sendspace=65536
no -r -o ipqmaxlen=512
no -r -o tcp_ephemeral_low=9000
no -r -o tcp_ephemeral_high=65500
no -r -o udp_ephemeral_low=9000
no -r -o udp_ephemeral_high=65500
```

## 7、调整虚拟内存参数

```SHELL
vmo -p -o minperm%=3
vmo -p -o maxperm%=90
vmo -p -o maxclient%=90
vmo -p -o lru_file_repage=0
vmo -p -o strict_maxclient=1
vmo -p -o strict_maxperm=0
```

## 8、修改oracle和root用户资源

```SHELL
vi /etc/security/liimts

default:
        fsize = -1
        data = -1
        stack = -1
        core = -1
        rss = -1
        nofiles = -1
```

## 9、修改用户最大进程数

```SHELL
lsattr -El sys0 -a maxuproc  --查看
chdev -l sys0 -a maxuproc=16384  --修改
```

## 10、分别配置oracle用户和grid用户等效性

```SHELL
在db1:
[oracle@db1 ~]$ mkdir ~/.ssh
[oracle@db1 ~]$ chmod 700 ~/.ssh
[oracle@db1 ~]$ ssh-keygen -t rsa
[oracle@db1 ~]$ ssh-keygen -t dsa

在db2：
[oracle@db2 ~]$ mkdir ~/.ssh
[oracle@db2 ~]$ chmod 700 ~/.ssh
[oracle@db2 ~]$ ssh-keygen -t rsa
[oracle@db2 ~]$ ssh-keygen -t dsa

切换回db1，接着执行：
[oracle@db1 ~]$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
[oracle@db1 ~]$ cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys

提示：下列命令会提示你输入bjgtj2 的oracle 密码，按照提示输入即可，如果失败可重新尝试执行命令。
db1 节点：
[oracle@db1 ~]$ scp ~/.ssh/authorized_keys db2:~/.ssh/authorized_keys

db2节点：
[oracle@db2 ~]$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
[oracle@db2 ~]$ cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
[oracle@db2 ~]$  scp ~/.ssh/authorized_keys db1:~/.ssh/authorized_keys

确保2个node都有相互的结点信息。两机相互执行。
[oracle@db1 ~]$ ssh db1 date
[oracle@db1~]$ ssh db2 date
[oracle@db1 ~]$ ssh db1-priv date
[oracle@db1 ~]$ ssh db2-priv date

切换至db2 执行
[oracle@db2 ~]$ ssh db1 date
[oracle@db2~]$ ssh db2 date
[oracle@db2 ~]$ ssh db1-priv date
[oracle@db2 ~]$ ssh db2-priv date
```

## 11、配置NTP服务

```SHELL
---配置ntp服务端
vi /etc/ntp.conf
#broadcastclient
server 127.127.1.0
driftfile /etc/ntp.drift 
tracefile /etc/ntp.trace 

启动xntpd守护进程
startsrc -s xntpd  
也可以使用smitty xntpd启动ntp服务，以后重启服务器后ntp自动启动
使用 lssrc -ls xntpd 查询xntpd状态
刚启动xntpd时, sys peer 为 'insane', 表明xntpd还没有完成同步，等待6-10分钟再次查询状态


---配置ntp客户端：
#broadcastclient 
server 192.168.150.225 
driftfile /etc/ntp.drift 
tracefile /etc/ntp.trace 

启动xntpd守护进程
startsrc -s xntpd
也可以使用smitty xntpd启动ntp服务，以后重启服务器后ntp自动启动
```

## 12、root.sh运行报错解决

```SHELL
# /u01/app/grid/grid_home/root.sh

Performing root user operation for Oracle 11g 

The following environment variables are set as:
    ORACLE_OWNER= grid
    ORACLE_HOME=  /u01/app/grid/grid_home

Enter the full pathname of the local bin directory: [/usr/local/bin]: 
The contents of "dbhome" have not changed. No need to overwrite.
The contents of "oraenv" have not changed. No need to overwrite.
The contents of "coraenv" have not changed. No need to overwrite.

Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Using configuration parameter file: /u01/app/grid/grid_home/crs/install/crsconfig_params
User ignored Prerequisites during installation
Installing Trace File Analyzer
User grid is missing the following capabilities required to run CSSD in realtime:
  CAP_NUMA_ATTACH,CAP_BYPASS_RAC_VMM,CAP_PROPAGATE
To add the required capabilities, please run:
   /usr/bin/chuser capabilities=CAP_NUMA_ATTACH,CAP_BYPASS_RAC_VMM,CAP_PROPAGATE grid
CSS cannot be run in realtime mode at /u01/app/grid/grid_home/crs/install/crsconfig_lib.pm line 11751.
/u01/app/grid/grid_home/perl/bin/perl -I/u01/app/grid/grid_home/perl/lib -I/u01/app/grid/grid_home/crs/install /u01/app/grid/grid_home/crs/install/rootcrs.pl execution failed
使用root用户运行/usr/bin/chuser capabilities=CAP_NUMA_ATTACH,CAP_BYPASS_RAC_VMM,CAP_PROPAGATE grid
然后重新运行/u01/app/grid/grid_home/root.sh
```



# oracle11.2.0.1升级至11.2.0.4（windows）

1， 升级前先停止原数据库（11.2.0.1）和监听

2， 解压11.2.0.4压缩包并执行setup

3，选择升级数据库

[![img](file:///C:\Users\ADMINI~1\AppData\Local\Temp\msohtmlclip1\01\clip_image002.png)](http://jingyan.baidu.com/album/cd4c29790b3c2f756f6e6041.html?picindex=5),

4，选择新版本数据库存放位置（不同于旧版本）

[![img](file:///C:\Users\ADMINI~1\AppData\Local\Temp\msohtmlclip1\01\clip_image004.png)](http://jingyan.baidu.com/album/cd4c29790b3c2f756f6e6041.html?picindex=8)0

5，安装到配置监听时直接取消安装

6，**启动原数据库（****11.2.0.1****）和监听**

7，**CD****到新的ORACLE_HOME\bin****目录下**如（E:\app\product\11.2.0\dbhome_1\BIN）并执行dbua

8，根据实际情况选择重新编译无效对象的并行度

[![img](file:///C:\Users\ADMINI~1\AppData\Local\Temp\msohtmlclip1\01\clip_image005.jpg)](http://jingyan.baidu.com/album/cd4c29790b3c2f756f6e6041.html?picindex=21)

9，在升级过程中选择**“****升级过程中移动数据库文件位置”**并指定一个新的存放数据文件的位置

10，取消无用的数据库特性

11，等待升级完成（时间较长）

12，升级完成后数据文库件会移动到新指定的位置，归档自动关闭，环境变量也会更新

13，**CD****到老版本数据库ORACLE_HOME\bin****目录下**并执行netca，删除旧的监听

14，根下直接执行netca创建新的监听

15，**到老版本的****ORACLE_HOME\deinstall****目录下**执行deinstall脚本删除旧版本的oracle软件



# 新装数据库调优

-----新建数据库后的优化工作

## 1、设置数据库归档

## 2、手动配置数据库的SGA与PGA，关闭11g自动内存管理，初始值根据经验估算初始值，后续必须在系统运行一段时间根据AWR调整

## 3、内存大于等于32GB时，需要配置hugepage

## 4、设置用户密码生命周期为永不过期，默认是180天自动过期  

```sql
alter profile default limit PASSWORD_LIFE_TIME UNLIMITED;
alter profile default limit FAILED_LOGIN_ATTEMPTS UNLIMITED;
alter system set sec_case_sensitive_logon=FALSE scope=both;
```

## 5、关闭direct path read 11g新特性

```sql
alter system set "_serial_direct_read"=never;
ALTER system SET EVENTS '10949 TRACE NAME CONTEXT  off';
```

## 6、调整表空间大小，包括system、sysaux、undo、temp

## 7、调整redo日志组以及日志成员大小

## 8、关闭防火墙  关闭selinux

## 9、controlfile文件复用

## 10、关闭数据库审计

```sql
SQL> show parameter audit
NAME                                 TYPE                              VALUE
------------------------------------ --------------------------------- ------------------------------
audit_file_dest                       string                            /oracle/app/oracle/admin/jgptsck/adump
audit_sys_operations             boolean                           FALSE
audit_syslog_level                  string
audit_trail                              string                            DB
SQL>alter system set audit_trail=none scope=spfile;
```

## 11、关闭RAC的DRM

```sql
下面的两个隐含参数设置后，DRM特性就关闭了，但需要重启数据库
SQL> alter system set "_gc_policy_time"=0 scope=spfile sid='*';
System altered.

SQL> alter system set "_gc_undo_affinity"=FALSE scope=spfile sid='*';
System altered.
```

## 12、调整参数CONTROL_FILE_RECORD_KEEP_TIME

## 13、linux6.4 设置虚拟内存参数

```sql
sysctl vm.swappiness=0                                                   
sysctl vm.dirty_background_ratio=3                                       
sysctl vm.dirty_ratio=80                                                 
sysctl vm.dirty_expire_centisecs=500                                     
sysctl vm.dirty_writeback_centisecs=100
```

## 14、 调整UNDO 和 Temp 表空间

```sql
[oracle@rac1 admin]$ ora param undo_
Session altered.
NAME                                     ISDEFAULT SESMO SYSMOD    VALUE
---------------------------------------- --------- ----- --------- ----------------------------------------
undo_management                          TRUE      FALSE FALSE     AUTO
undo_tablespace                          FALSE     FALSE IMMEDIATE UNDOTBS1
undo_retention                           TRUE      FALSE IMMEDIATE 900

undo_retention 只是指定undo 数据的过期时间，默认是900s，15分钟。建议改成3600s，即1个小时。
SQL&get; alter system set undo_retention=3600 scope=both sid='*';
System altered.

另外，UNDO 表空间必须设置成自动扩展并限制最大值。
ALTER DATABASE DATAFILE '+DATA'  AUTOEXTEND ON NEXT 1M MAXSIZE 30720M;
```



