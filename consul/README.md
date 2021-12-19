#  一、概述

> consul是google开源的一个使用go语言开发的服务发现、配置管理中心服务。内置了服务注册与发现框 架、分布一致性协议实现、健康检查、Key/Value存储、多数据中心方案，不再需要依赖其他工具（比如ZooKeeper等）。服务部署简单，只有一个可运行的二进制的包。每个节点都需要运行agent，他有两种运行模式server和client。每个数据中心官方建议需要3或5个server节点以保证数据安全，同时保证server-leader的选举能够正确的进行。


# 二、特征

* 服务发现: Consul 提供了通过 DNS 或者 HTTP 接口的方式来注册服务和发现服务。一些外部的服务通过 Consul 很容易的找到它所依赖的服务。
* 健康检测: Consul 的 Client 提供了健康检查的机制，可以通过用来避免流量被转发到有故障的服务上。
* Key/Value 存储: 应用程序可以根据自己的需要使用 Consul 提供的 Key/Value 存储。 Consul 提供了简单易用的 HTTP 接口，结合其他工具可以实现动态配置、功能标记、领袖选举等等功能。
* 多数据中心: Consul 支持开箱即用的多数据中心. 这意味着用户不需要担心需要建立额外的抽象层让业务扩展到多个区域。



@client

CLIENT表示consul的client模式，就是客户端模式。是consul节点的一种模式，这种模式下，所有注册到当前节点的服务会被转发到SERVER，本身是不持久化这些信息。

@server

SERVER表示consul的server模式，表明这个consul是个server，这种模式下，功能和CLIENT都一样，唯一不同的是，它会把所有的信息持久化的本地，这样遇到故障，信息是可以被保留的。

@server-leader

中间那个SERVER下面有LEADER的字眼，表明这个SERVER是它们的老大，它和其它SERVER不一样的一点是，它需要负责同步注册的信息给其它的SERVER，同时也要负责各个节点的健康监测。

@raft

server节点之间的数据一致性保证，一致性协议使用的是raft，而zookeeper用的paxos，etcd采用的也是raft。

@服务发现协议

consul采用http和dns协议，etcd只支持http

@服务注册

consul支持两种方式实现服务注册，一种是通过consul的服务注册http API，由服务自己调用API实现注册，另一种方式是通过json个是的配置文件实现注册，将需要注册的服务以json格式的配置文件给出。consul官方建议使用第二种方式。

@服务发现

consul支持两种方式实现服务发现，一种是通过http API来查询有哪些服务，另外一种是通过consul agent 自带的DNS（8600端口），域名是以NAME.service.consul的形式给出，NAME即在定义的服务配置文件中，服务的名称。DNS方式可以通过check的方式检查服务。

@服务间的通信协议

Consul使用gossip协议管理成员关系、广播消息到整个集群，他有两个gossip  pool（LAN pool和WAN pool），LAN pool是同一个数据中心内部通信的，WAN pool是多个数据中心通信的，LAN pool有多个，WAN pool只有一个。


# 三、consul与其他框架差异


<table>
<thead>
<tr>
<th><strong>名称</strong></th>
<th><strong>优点</strong></th>
<th><strong>缺点</strong></th>
<th><strong>接口</strong></th>
<th><strong>一致性算法</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td>zookeeper</td>
<td>1.功能强大，不仅仅只是服务发现 2.提供 watcher 机制能实时获取服务提供者的状态 3.dubbo 等框架支持</td>
<td>1.没有健康检查 2.需在服务中集成 sdk，复杂度高 3.不支持多数据中心</td>
<td>sdk</td>
<td>Paxos</td>
</tr>
<tr>
<td>consul</td>
<td>1.简单易用，不需要集成 sdk 2.自带健康检查 3.支持多数据中心 4.提供 web 管理界面</td>
<td>1.不能实时获取服务信息的变化通知</td>
<td>http/dns</td>
<td>Raft</td>
</tr>
<tr>
<td>etcd</td>
<td>1.简单易用，不需要集成 sdk 2.可配置性强</td>
<td>1.没有健康检查 2.需配合第三方工具一起完成服务发现 3.不支持多数据中心</td>
<td>http</td>
<td>Raft</td>
</tr>
</tbody>
</table>


# Consul 和 eureka的对比


<table><thead><tr><th>Feature</th><th>Euerka</th><th>Consul</th></tr></thead><tbody><tr><td>服务健康检查</td><td>可配支持</td><td>服务状态，内存，硬盘等</td></tr><tr><td>多数据中心</td><td>—</td><td>支持</td></tr><tr><td>kv 存储服务</td><td>—</td><td>支持</td></tr><tr><td>一致性</td><td>—</td><td>raft</td></tr><tr><td>cap</td><td>ap</td><td>cp</td></tr><tr><td>使用接口(多语言能力)</td><td>http（sidecar）</td><td>支持 http 和 dns</td></tr><tr><td>watch 支持</td><td>支持 long polling/大部分增量</td><td>全量/支持long polling</td></tr><tr><td>自身监控</td><td>metrics</td><td>metrics</td></tr><tr><td>安全</td><td>—</td><td>acl /https</td></tr><tr><td>编程语言</td><td>Java</td><td>go</td></tr><tr><td>Spring Cloud 集成</td><td>已支持</td><td>已支持</td></tr></tbody></table>

