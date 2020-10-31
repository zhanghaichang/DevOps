# Prometheus

> Prometheus(中文名:普罗米修斯)是由SoundCloud开发的开源监控报警系统和时序列数据库(TSDB). Prometheus使用Go语言开发, 是Google BorgMon监控系统的开源版本。

> Prometheus的基本原理是通过HTTP协议周期性抓取被监控组件的状态, 任意组件只要提供对应的HTTP接口就可以接入监控. 不需要任何SDK或者其他的集成过程。输出被监控组件信息的HTTP接口被叫做exporter，目前开发常用的组件大部分都有exporter可以直接使用, 比如Nginx、MySQL、Linux系统信息、Mongo、ES等



官网下载（https://prometheus.io/)，支持Linux、Mac、Windows系统，很好很强大。我这里安装过Centos和Mac，这里的实例以Mac为准
