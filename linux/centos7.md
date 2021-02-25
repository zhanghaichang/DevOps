# centos7系统优化配置

调优是在当前系统或应用有性能瓶颈时才需要做的一个事情，如果当前应用能够很好的支持负载响应，就没必要做调优。调优并不是一次把所有配置都更新，而是通过分析，找到问题瓶颈原因，再依次修改相关参数，一步一步进行验证解决的最佳的调优配置是不存在的，这里也是参考值，不同的机器发挥出最大的性能还需要继续调整参数

```shell
cat <<EOF >> /etc/security/limits.conf
# 限制内核文件大小为0
* - core 0
# 增大最小文件句柄数
* - nofile 65535
# 增大最小进程数
* - nproc 65535
# 文件大小无限制
* - fsize unlimited
# 虚拟内存无限制
* - as unlimited
EOF
```

配置内核调优

```shell
cat <<EOF >>/etc/sysctl.conf
# 增大每个套接字缓冲区大小
net.core.optmem_max = 81920
# 增大套接字接收缓冲区大小
net.core.rmem_max = 513920
# 增大套接字发送缓冲区大小
net.core.wmem_max = 513920
# 增大TCP接收缓冲区范围
net.ipv4.tcp_rmem = 4096 87380 16777216
# 增大TCP发送缓冲区范围
net.ipv4.tcp_wmem = 4096 87380 16777216
# 支持更大的TCP窗口. 如果TCP窗口最大超过65535(64K), 必须设置该数值为1
net.ipv4.tcp_window_scaling = 1
# 增大UDP缓冲区范围
net.ipv4.udp_mem = 188562 251418 377124
# 增大网卡队列深度
net.core.netdev_max_backlog = 262144

# 增大连接跟踪表大小
net.netfilter.nf_conntrack_max = 1048576
net.netfilter.nf_conntrack_buckets = 65536
# 增大处于TIME_WAIT状态连接数量
net.ipv4.tcp_max_tw_buckets = 1048576
# 缩短处于TIME_WAIT状态的超时时间
net.ipv4.tcp_fin_timeout = 15
# 缩短连接跟踪表中处于TIME_WAIT状态的超时时间
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 30
# 允许TIME_WAIT状态占用端口还可以用到新建的连接中
net.ipv4.tcp_tw_reuse = 1
# 增大本地端口号范围
net.ipv4.ip_local_port_range = 5000 65000
# 缩短发送keepalive探测包发送间隔时间
net.ipv4.tcp_keepalive_intvl = 30
# 减少keepalive探测失败后重试次数
net.ipv4.tcp_keepalive_probes = 3
# 缩短最后一次数据包到keepalive探测包间隔时间
net.ipv4.tcp_keepalive_time = 600

# 开启网络转发,容器环境必须开启
net.ipv4.ip_forward = 1
# 默认TTL为64,增大会降低性能
net.ipv4.ip_default_ttl = 64

# 数据包反向地址校验,防止IP欺骗，减少DDos攻击
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
# 处理无源路由包
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
# 禁用ICMP协议
net.ipv4.icmp_echo_ignore_all = 1
# 禁用广播ICMP
net.ipv4.icmp_echo_ignore_broadcasts = 1
# 开启恶意ICMP错误消息保护
net.ipv4.icmp_ignore_bogus_error_responses = 1
# 开启SYN Cookie,防止SYN洪水攻击
net.ipv4.tcp_syncookies = 1

# 增大系统中每一个端口最大的监听队列的长度
net.core.somaxconn = 4096
# 限制一个进程可以拥有的VMA(虚拟内存区域)的数量
vm.max_map_count = 262145

# iptables对bridge的数据进行处理
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1

# 增大ARP缓存表
net.ipv4.neigh.default.gc_thresh1 = 4096
net.ipv4.neigh.default.gc_thresh2 = 6144
net.ipv4.neigh.default.gc_thresh3 = 8192

# 脏页内存最多占用阈值2GB,文件系统写缓冲区大小,写缓冲使用到系统内存多少的时候，
# 开始向磁盘写出数据。增大之会使用更多系统内存用于磁盘写缓冲，也可以极大提高系统的写性能
vm.dirty_bytes = 2147483648
# 脏页内存占用阈值1GB,写缓冲使用到系统内存多少的时候，pdflush开始向磁盘写出数据
vm.dirty_background_bytes = 1073741824
# 脏页内存数据刷新进程pdflush的运行间隔2s,默认5s
vm.dirty_writeback_centisecs = 200
# 脏数据能存活的时间10s,默认30s,Linux内核写缓冲区里面的数据多“旧”了之后，
# pdflush进程就开始考虑写到磁盘中去
vm.dirty_expire_centisecs = 1000

# 增加系统文件描述符限制
fs.file-max = 1635927

# 使用sysrq组合键是了解系统目前运行情况，为安全起见设为0关闭
kernel.sysrq = 0
# 每个消息队列的大小（单位：字节）限制,默认16384
kernel.msgmnb = 16384
# 整个系统最大消息队列数量限制,默认8192
kernel.msgmax = 8192
EOF
sysctl -p

```
