## Linux设置和修改时间与时区

### 方法一

#### 一、date 查看/设置系统时间

```
1、将日期设置为2017年11月3日
[root@linux-node ~]# date -s 11/03/17

2、将时间设置为14点20分50秒
[root@linux-node ~]# date -s 14:20:50

3、将时间设置为2017年11月3日14点16分30秒（MMDDhhmmYYYY.ss）
[root@linux-node ~]# date 1103141617.30

```

#### 二、hwclock/clock 查看/设置硬件时间
```
1、查看系统硬件时钟
[root@linux-node ~]# hwclock  --show 或者
[root@linux-node ~]# clock  --show

2、设置硬件时间
[root@linux-node ~]# hwclock --set --date="11/03/17 14:55" （月/日/年时:分:秒） 或者
[root@linux-node ~]# clock --set --date="11/03/17 14:55" （月/日/年时:分:秒）

```

#### 三、同步系统及硬件时钟
```
[root@linux-node ~]# hwclock --hctosys 或者
[root@linux-node ~]# clock --hctosys  
备注：hc代表硬件时间，sys代表系统时间，以硬件时间为基准，系统时间找硬件时间同步


[root@linux-node ~]# hwclock --systohc或者
[root@linux-node ~]# clock --systohc 
备注：以系统时间为基准，硬件时间找系统时间同步

```

## 方法二

时区设置用tzselect 命令来实现。但是通过tzselect命令设置TZ这个环境变量来选择的时区，需要将变量添加到.profile文件中

#### 一、tzselect命令执行
> 执行tzselect命令 --> 选择Asia --> 选择China --> 选择east China - Beijing, Guangdong, Shanghai, etc-->然后输入1。

执行完tzselect命令选择时区后，时区并没有更改，只是在命令最后提示你可以执行 TZ=’Asia/Shanghai’; export TZ 并将这行命令添加到.profile中，然后退出并重新登录。

#### 二、修改配置文件来修改时区

```
[root@linux-node ~]# echo "ZONE=Asia/Shanghai" >> /etc/sysconfig/clock         
[root@linux-node ~]# rm -f /etc/localtime
#链接到上海时区文件       
[root@linux-node ~]# ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```
#### 备注：

执行完上述过程后，重启机器，即可看到时区已经更改。

```
在centos7中设置时区的命令可以通过 timedatectl 命令来实现
[root@linux-node ~]# timedatectl set-timezone Asia/Shanghai
```
