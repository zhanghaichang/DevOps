## 1、查看系统是否已安装NFS

```
[root@bogon ~]# rpm -qa | grep nfs
[root@bogon ~]# rpm -qa | grep rpcbind
```


## 2、安装NFS

```
[root@bogon ~]# yum -y install nfs-utils rpcbind
已加载插件：fastestmirror
设置安装进程
Loading mirror speeds from cached hostfile
... ...
已安装:
  nfs-utils.x86_64 1:1.2.3-70.el6_8.2                           rpcbind.x86_64 0:0.2.0-12.el6                          

作为依赖被安装:
  keyutils.x86_64 0:1.4-5.el6         libevent.x86_64 0:1.4.13-4.el6         libgssglue.x86_64 0:0.1-11.el6           
  libtirpc.x86_64 0:0.2.1-11.el6_8    nfs-utils-lib.x86_64 0:1.1.5-11.el6    python-argparse.noarch 0:1.2.1-2.1.el6   

完毕！
```

## 五、服务端配置
 
在NFS服务端上创建共享目录/data/lys并设置权限
```
[root@bogon ~]# mkdir -p /data/k8s
[root@bogon ~]# ll /data/
```

编辑export文件

```
[root@bogon ~]# vim /etc/exports 

/data/k8s 192.168.2.0/24(rw,no_root_squash,no_all_squash,sync)
```
常见的参数则有：

参数值    内容说明
rw　　ro    该目录分享的权限是可擦写 (read-write) 或只读 (read-only)，但最终能不能读写，还是与文件系统的 rwx 及身份有关。

sync　　async    sync 代表数据会同步写入到内存与硬盘中，async 则代表数据会先暂存于内存当中，而非直接写入硬盘！

no_root_squash　　root_squash    客户端使用 NFS 文件系统的账号若为 root 时，系统该如何判断这个账号的身份？预设的情况下，客户端 root 的身份会由 root_squash 的设定压缩成 nfsnobody， 如此对服务器的系统会较有保障。但如果你想要开放客户端使用 root 身份来操作服务器的文件系统，那么这里就得要开 no_root_squash 才行！

all_squash    不论登入 NFS 的使用者身份为何， 他的身份都会被压缩成为匿名用户，通常也就是 nobody(nfsnobody) 啦！

anonuid　　anongid    anon 意指 anonymous (匿名者) 前面关于 *_squash 提到的匿名用户的 UID 设定值，通常为 nobody(nfsnobody)，但是你可以自行设定这个 UID 的值！当然，这个 UID 必需要存在于你的 /etc/passwd 当中！ anonuid 指的是 UID 而 anongid 则是群组的 GID 啰。

### 配置生效

```
[root@bogon lys]# exportfs -r
```

启动rpcbind、nfs服务


```
[root@bogon lys]# service rpcbind start
正在启动 rpcbind：                                         [确定]
[root@bogon lys]# service nfs start
启动 NFS 服务：                                            [确定]
启动 NFS mountd：                                          [确定]
启动 NFS 守护进程：                                        [确定]
正在启动 RPC idmapd：                                      [确定]

```

查看 RPC 服务的注册状况

```
[root@bogon lys]# rpcinfo -p localhost
   program vers proto   port  service
    100000    4   tcp    111  portmapper
    100000    3   tcp    111  portmapper
    100000    2   tcp    111  portmapper
    100000    4   udp    111  portmapper
    100000    3   udp    111  portmapper
    100000    2   udp    111  portmapper
    100005    1   udp  49979  mountd
    100005    1   tcp  58393  mountd
    100005    2   udp  45516  mountd
    100005    2   tcp  37792  mountd
    100005    3   udp  32997  mountd
    100005    3   tcp  39937  mountd
    100003    2   tcp   2049  nfs
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100227    2   tcp   2049  nfs_acl
    100227    3   tcp   2049  nfs_acl
    100003    2   udp   2049  nfs
    100003    3   udp   2049  nfs
    100003    4   udp   2049  nfs
    100227    2   udp   2049  nfs_acl
    100227    3   udp   2049  nfs_acl
    100021    1   udp  51112  nlockmgr
    100021    3   udp  51112  nlockmgr
    100021    4   udp  51112  nlockmgr
    100021    1   tcp  43271  nlockmgr
    100021    3   tcp  43271  nlockmgr
    100021    4   tcp  43271  nlockmgr

选项与参数：
-p ：针对某 IP (未写则预设为本机) 显示出所有的 port 与 porgram 的信息；
-t ：针对某主机的某支程序检查其 TCP 封包所在的软件版本；
-u ：针对某主机的某支程序检查其 UDP 封包所在的软件版本；
```
在你的 NFS 服务器设定妥当之后，我们可以在 server 端先自我测试一下是否可以联机喔！就是利用 showmount 这个指令来查阅！

```
[root@bogon lys]# showmount -e localhost
Export list for localhost:
/data/k8s 192.168.2.0/24
选项与参数：
-a ：显示目前主机与客户端的 NFS 联机分享的状态；
-e ：显示某部主机的 /etc/exports 所分享的目录数据。
```

## 六、客户端配置

安装nfs-utils客户端

```
[root@bogon ~]# yum -y install nfs-utils
已安装:
  nfs-utils.x86_64 1:1.2.3-70.el6_8.2                                                                                  

作为依赖被安装:
  keyutils.x86_64 0:1.4-5.el6         libevent.x86_64 0:1.4.13-4.el6         libgssglue.x86_64 0:0.1-11.el6           
  libtirpc.x86_64 0:0.2.1-11.el6_8    nfs-utils-lib.x86_64 0:1.1.5-11.el6    python-argparse.noarch 0:1.2.1-2.1.el6   
  rpcbind.x86_64 0:0.2.0-12.el6      

完毕！
```
 

创建挂载目录

```
[root@bogon ~]# mkdir -p /data/k8s
```
查看服务器抛出的共享目录信息

```
[root@bogon ~]# showmount -e 192.168.2.203
Export list for 192.168.2.203:
/data/k8s 192.168.2.0/24
```
为了提高NFS的稳定性，使用TCP协议挂载，NFS默认用UDP协议

```
               mount  -t  nfs   服务器IP:/服务器目录      客户端挂载目录 
[root@bogon ~]# mount -t nfs 192.168.1.13:/data/k8s /data/k8s -o proto=tcp -o nolock
```
## 七、测试结果

查看挂载结果

```
[root@bogon ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup-lv_root
                       18G  1.1G   16G   7% /
tmpfs                 112M     0  112M   0% /dev/shm
/dev/sda1             477M   54M  398M  12% /boot
192.168.2.203:/data/k8s
                       18G  1.1G   16G   7% /lys
```

服务端

```
[root@bogon lys]# echo "test" > test.txt
```
客户端
```
[root@bogon ~]# cat /data/k8s/test.txt 
test
[root@bogon ~]# echo "204" >> /k8s/test.txt 
```
服务端
```
[root@bogon lys]# cat /data/k8s/test.txt 
test
204
```
卸载已挂在的NFS

```
[root@bogon ~]# umount /data/k8s/
[root@bogon ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup-lv_root
                       18G  1.1G   16G   7% /
tmpfs                 112M     0  112M   0% /dev/shm
/dev/sda1             477M   54M  398M  12% /boot
```
 

### 开机自动挂载：

如果服务端或客户端的服务器重启之后需要手动挂载，我们可以加入到开机自动挂载

在客户端/etc/fstab里添加

> 192.168.1.13:/data/k8s      /data/k8s      nfs  defaults,_rnetdev  1  1

备注：第1个1表示备份文件系统，第2个1表示从/分区的顺序开始fsck磁盘检测，0表示不检测。

_rnetdev  表示主机无法挂载直接跳过，避免无法挂载主机无法启动


到此结束

 

补充部分：

为了方便配置防火墙，需要固定nfs服务端口

NFS启动时会随机启动多个端口并向RPC注册，这样如果使用iptables对NFS端口进行限制就会有点麻烦，可以更改配置文件固定NFS服务相关端口。

```
[root@bogon lys]# rpcinfo -p localhost
   program vers proto   port  service
    100000    4   tcp    111  portmapper
    100000    3   tcp    111  portmapper
    100000    2   tcp    111  portmapper
    100000    4   udp    111  portmapper
    100000    3   udp    111  portmapper
    100000    2   udp    111  portmapper
    100005    1   udp  49979  mountd
    100005    1   tcp  58393  mountd
    100005    2   udp  45516  mountd
    100005    2   tcp  37792  mountd
    100005    3   udp  32997  mountd
    100005    3   tcp  39937  mountd
    100003    2   tcp   2049  nfs
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100227    2   tcp   2049  nfs_acl
    100227    3   tcp   2049  nfs_acl
    100003    2   udp   2049  nfs
    100003    3   udp   2049  nfs
    100003    4   udp   2049  nfs
    100227    2   udp   2049  nfs_acl
    100227    3   udp   2049  nfs_acl
    100021    1   udp  51112  nlockmgr
    100021    3   udp  51112  nlockmgr
    100021    4   udp  51112  nlockmgr
    100021    1   tcp  43271  nlockmgr
    100021    3   tcp  43271  nlockmgr
    100021    4   tcp  43271  nlockmgr
```

分配端口，编辑配置文件：

```
[root@bogon lys]# vim /etc/sysconfig/nfs
```

添加：

RQUOTAD_PORT=30001
LOCKD_TCPPORT=30002
LOCKD_UDPPORT=30002
MOUNTD_PORT=30003
STATD_PORT=30004                   
重启

```
[root@bogon lys]# service nfs restart
关闭 NFS 守护进程：                                        [确定]
关闭 NFS mountd：                                          [确定]
关闭 NFS 服务：                                            [确定]
Shutting down RPC idmapd:                                  [确定]
启动 NFS 服务：                                            [确定]
启动 NFS mountd：                                          [确定]
启动 NFS 守护进程：                                        [确定]
正在启动 RPC idmapd：                                      [确定]
```

查看结果

```
[root@bogon lys]# rpcinfo -p localhost
   program vers proto   port  service
    100000    4   tcp    111  portmapper
    100000    3   tcp    111  portmapper
    100000    2   tcp    111  portmapper
    100000    4   udp    111  portmapper
    100000    3   udp    111  portmapper
    100000    2   udp    111  portmapper
    100005    1   udp  30003  mountd
    100005    1   tcp  30003  mountd
    100005    2   udp  30003  mountd
    100005    2   tcp  30003  mountd
    100005    3   udp  30003  mountd
    100005    3   tcp  30003  mountd
    100003    2   tcp   2049  nfs
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100227    2   tcp   2049  nfs_acl
    100227    3   tcp   2049  nfs_acl
    100003    2   udp   2049  nfs
    100003    3   udp   2049  nfs
    100003    4   udp   2049  nfs
    100227    2   udp   2049  nfs_acl
    100227    3   udp   2049  nfs_acl
    100021    1   udp  30002  nlockmgr
    100021    3   udp  30002  nlockmgr
    100021    4   udp  30002  nlockmgr
    100021    1   tcp  30002  nlockmgr
    100021    3   tcp  30002  nlockmgr
    100021    4   tcp  30002  nlockmgr
```

可以看到，随机端口以固定

iptables策略问题完美解决！！！
