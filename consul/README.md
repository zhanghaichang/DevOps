#  一、概述

> consul是google开源的一个使用go语言开发的服务发现、配置管理中心服务。内置了服务注册与发现框 架、分布一致性协议实现、健康检查、Key/Value存储、多数据中心方案，不再需要依赖其他工具（比如ZooKeeper等）。服务部署简单，只有一个可运行的二进制的包。每个节点都需要运行agent，他有两种运行模式server和client。每个数据中心官方建议需要3或5个server节点以保证数据安全，同时保证server-leader的选举能够正确的进行。


# 二、特征

* 服务发现: Consul 提供了通过 DNS 或者 HTTP 接口的方式来注册服务和发现服务。一些外部的服务通过 Consul 很容易的找到它所依赖的服务。
* 健康检测: Consul 的 Client 提供了健康检查的机制，可以通过用来避免流量被转发到有故障的服务上。
* Key/Value 存储: 应用程序可以根据自己的需要使用 Consul 提供的 Key/Value 存储。 Consul 提供了简单易用的 HTTP 接口，结合其他工具可以实现动态配置、功能标记、领袖选举等等功能。
* 多数据中心: Consul 支持开箱即用的多数据中心. 这意味着用户不需要担心需要建立额外的抽象层让业务扩展到多个区域。




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
