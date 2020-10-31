# Prometheus

> Prometheus(中文名:普罗米修斯)是由SoundCloud开发的开源监控报警系统和时序列数据库(TSDB). Prometheus使用Go语言开发, 是Google BorgMon监控系统的开源版本。

### Prometheus的特点

* 多维度数据模型。
* 灵活的查询语言。
* 不依赖分布式存储，单个服务器节点是自主的。
* 通过基于HTTP的pull方式采集时序数据。
* 可以通过中间网关进行时序列数据推送。
* 通过服务发现或者静态配置来发现目标服务对象。
* 支持多种多样的图表和界面展示，比如Grafana等。

### Prometheus监控基本原理

Prometheus的基本原理是通过HTTP协议周期性抓取被监控组件的状态，任意组件只要提供对应的HTTP接口就可以接入监控。不需要任何SDK或者其他的集成过程。这样做非常适合做虚拟化环境监控系统，比如VM、Docker、Kubernetes等。输出被监控组件信息的HTTP接口被叫做exporter 。目前互联网公司常用的组件大部分都有exporter可以直接使用，比如Varnish、Haproxy、Nginx、MySQL、Linux系统信息(包括磁盘、内存、CPU、网络等等)。

### Prometheus 三大套件
* Server 主要负责数据采集和存储，提供PromQL查询语言的支持。
* Alertmanager 警告管理器，用来进行报警。
* Push Gateway 支持临时性Job主动推送指标的中间网关。



官网下载（https://prometheus.io/)，支持Linux、Mac、Windows系统，很好很强大。我这里安装过Centos和Mac，这里的实例以Mac为准
