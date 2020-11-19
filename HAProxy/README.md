# HAProxy

> 是一款提供高可用性、负载均衡以及基于TCP（第四层）和HTTP（第七层）应用的代理软件，支持虚拟主机，它是免费、快速并且可靠的一种解决方案。



1.创建日志目录：

```
# mkdir /var/log/haproxy
# chmod a+w /var/log/haproxy
```

2.开启rsyslog记录haproxy日志：

```
# vim /etc/rsyslog.conf

# Provides UDP syslog reception
$ModLoad imudp    # 
$UDPServerRun 514

# haproxy log
local0.*    /var/log/haproxy/haproxy.log  # 添加

```
3.修改 /etc/sysconfig/rsyslog 文件：

```
# Options for rsyslogd
# Syslogd options are deprecated since rsyslog v3.
# If you want to use them, switch to compatibility mode 2 by "-c 2"
# See rsyslogd(8) for more details
SYSLOGD_OPTIONS="-r -m 0 -c 2"

```
4.重启rsyslog，使日志配置生效：

```
# systemctl restart rsyslog
```
5.yum安装HAProxy

```
yum install -y haproxy
```

6.HAProxy的配置文件路径为：/etc/haproxy/haproxy.cfg

主程序路径为：/usr/sbin/haproxy






8.检查haproxy配置是否有效：

```
# haproxy -c -f /etc/haproxy/haproxy.cfg 
...
Configuration file is valid  # 有效，警告可以处理，一般都是 log类型，option tcplog, http的option forwardfor

```

9.haproxy管理命令：

```
# 启动
$ systemctl start haproxy.service
# 停止
$ systemctl stop haproxy.service
# 修改配置重新加载
$ systemctl reload haproxy.service
# 重启
$ systemctl restart haproxy.service

```


10.查看监听端口，监听端口为bind的端口：

```
# netstat -lnpt

```
