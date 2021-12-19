# consul 搭建


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


## 安装

```
1.下载并解压consul

cd /opt/

mkdir consul

chmod 777 consul

cd consul

wget https://releases.hashicorp.com/consul/1.11.1/consul_1.11.1_linux_amd64.zip

unzip consul_1.11.1_linux_amd64.zip

# cp consul /usr/local/bin/

2. 检查是否安装成功
# consul

# consul version

#前台启动
consul agent -server -bind=10.36.11.161 -client=10.36.11.161 -ui -data-dir /home/consul -node=agent-one -bootstrap


#后台启动
nohup consul agent -server -bind=10.36.11.161 -client=10.36.11.161 -ui -data-dir /home/consul -node=agent-one -bootstrap >> /home/logs/consul.log &

说明: 
bind  集群通信(只能指定ip 不能用0.0.0.0)
client 客户端通信(只能指定ip 不能用0.0.0.0)

3.浏览器输入:http://IP:8500/出现ConsulWeb界面就表示成功了
```

## consul集群搭建

1）安装

首先去官网现在合适的consul包：https://www.consul.io/downloads.html

安装直接下载zip包，解压后只有一个可执行的文件consul，将consul添加到系统的环境变量里面。

#unzip consul_1.2.3_linux_amd64.zip

#cp -a consul  /usr/bin

#consul

```
Usage: consul [--version] [--help] <command> [<args>]

Available commands are:
    agent          Runs a Consul agent
    catalog        Interact with the catalog
    connect        Interact with Consul Connect
    event          Fire a new event
    exec           Executes a command on Consul nodes
    force-leave    Forces a member of the cluster to enter the "left" state
    info           Provides debugging information for operators.
    intention      Interact with Connect service intentions
    join           Tell Consul agent to join cluster
    keygen         Generates a new encryption key
    keyring        Manages gossip layer encryption keys
    kv             Interact with the key-value store
    leave          Gracefully leaves the Consul cluster and shuts down
    lock           Execute a command holding a lock
    maint          Controls node or service maintenance mode
    members        Lists the members of a Consul cluster
    monitor        Stream logs from a Consul agent
    operator       Provides cluster-level tools for Consul operators
    reload         Triggers the agent to reload configuration files
    rtt            Estimates network round trip time between nodes
    snapshot       Saves, restores and inspects snapshots of Consul server state
    validate       Validate config files/directories
    version        Prints the Consul version
    watch          Watch for changes in Consul
```

输入consul，出现上面的内容证明安装成功。

 

2）启动

consul必须启动agent才能使用，有两种启动模式server和client，还有一个官方自带的ui。server用与持久化服务信息，集群官方建议3或5个节点。client只用与于server交互。ui可以查看集群情况的。

server：

cn1：

#consul agent  -bootstrap-expect 2  -server   -data-dir /data/consul0 -node=cn1 -bind=192.168.1.202 -config-dir /etc/consul.d -enable-script-checks=true  -datacenter=dc1 

cn2:

#consul agent    -server  -data-dir /data/consul0 -node=cn2 -bind=192.168.1.201 -config-dir /etc/consul.d -enable-script-checks=true  -datacenter=dc1  -join 192.168.1.202

cn3:

#consul agent  -server  -data-dir /data/consul0 -node=cn3 -bind=192.168.1.200 -config-dir /etc/consul.d -enable-script-checks=true  -datacenter=dc1  -join 192.168.1.202

参数解释：

-bootstrap-expect:集群期望的节点数，只有节点数量达到这个值才会选举leader。

-server： 运行在server模式

-data-dir：指定数据目录，其他的节点对于这个目录必须有读的权限

-node：指定节点的名称

-bind：为该节点绑定一个地址

-config-dir：指定配置文件，定义服务的，默认所有一.json结尾的文件都会读

-enable-script-checks=true：设置检查服务为可用

-datacenter: 数据中心没名称，

-join：加入到已有的集群中

 

client：

#consul agent   -data-dir /data/consul0 -node=cn4 -bind=192.168.1.199 -config-dir /etc/consul.d -enable-script-checks=true  -datacenter=dc1  -join 192.168.1.202

client节点可以有多个，自己根据服务指定即可。

ui:

#consul agent  -ui  -data-dir /data/consul0 -node=cn4 -bind=192.168.1.198  -client 192.168.1.198   -config-dir /etc/consul.d -enable-script-checks=true  -datacenter=dc1  -join 192.168.1.202

 -ui:使用自带的ui，

-ui-dir：指定ui的目录，使用自己定义的ui

-client：指定web  ui、的监听地址，默认127.0.0.1只能本机访问。

集群创建完成后：

使用一些常用的命令检查集群的状态：

#consul  info

可以在raft：stat看到此节点的状态是Fllower或者leader

#consul members

Node Address Status Type Build Protocol DC Segment
cn1 192.168.1.202:8301 alive server 1.0.2 2 dc1 <all>
cn2 192.168.1.201:8301 alive server 1.0.2 2 dc1 <all>
cn3 192.168.1.200:8301 alive client 1.0.2 2 dc1 <default>

新加入一个节点有几种方式；

1、这种方式，重启后不会自动加入集群

#consul  join  192.168.1.202

2、#在启动的时候使用-join指定一个集群

#consul agent  -ui  -data-dir /data/consul0 -node=cn4 -bind=192.168.1.198 -config-dir /etc/consul.d -enable-script-checks=true  -datacenter=dc1  -join 192.168.1.202

3、使用-startjoin或-rejoin

#consul agent  -ui  -data-dir /data/consul0 -node=cn4 -bind=192.168.1.198 -config-dir /etc/consul.d -enable-script-checks=true  -datacenter=dc1  -rejoin

 

访问ui：

http://192.168.1.198:8500/ui

端口：

8300：consul agent服务relplaction、rpc（client-server）

8301：lan gossip

8302：wan gossip

8500：http api端口

8600：DNS服务端口

 

3）服务注册

采用的是配置文件的方式，（官方推荐）首先创建一个目录用于存放定义服务的配置文件

#mkdir /etc/consul.d/

启动服务的时候要使用-config-dir 参数指定。

下面给出一个服务定义：
  
#cat web.json


```json
 {
    "service":{
        "name":"web",
        "tags":[
            "rails"
        ],
        "port":80,
        "check":{
            "name":"ping",
            "script":"curl -s localhost:80",
            "interval":"3s"
        }
    }
}
```
