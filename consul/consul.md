# consul 集群搭建


## linux 安装

```shell
wget https://releases.hashicorp.com/consul/1.5.1/consul_1.5.1_linux_amd64.zip
unzip consul_0.8.1_linux_amd64.zip
mv consul /usr/local/bin/

```

### perviosr启动

```
mkdir -p /data/consul/{data,logs}

cat < /etc/supervisord.d/consul.conf >EOF
[program:consul]
command=consul agent -server -bootstrap-expect 3 -data-dir /data/consul/data -bind=172.16.100.2 -ui -client 0.0.0.0 -advertise=172.16.100.2 -node=go2cloud-platform-test -rejoin
user=root
stdout_logfile=/data/consul/logs/consul.log
autostart=true
autorestart=true
startsecs=60
stopasgroup=true
ikillasgroup=true
startretries=1
redirect_stderr=true
EOF

```

### 启动后需要手动在其他两个节点手动加入consul join 172.16.100.2


### 查看

```
[root@go2cloud_platform_pord conf.d]# supervisorctl status consul
consul                           RUNNING   pid 11838, uptime 0:13:28

```

### 其他命令


```
# 查看集群成员
consul members

# 查看集群状态
consul info

# 帮助
consul agent -h

```
