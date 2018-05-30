## 容器监控方案
 
kubernetes、promethues、influxdata等开源组织相继发布了一些容器监控工具和方案。

* kubernetes 的 heapster+influxdb+grafana
* prometheus的prometheus+alertmanager
* influxdata的telegraf+influxdb+kapacitor。


## 监控工具的对比
---------

以上从几个典型的架构上介绍了一些监控，但都不是最优实践。需要根据生产环境的特点结合每个监控产品的优势来达到监控的目的。比如Grafana的图表展示能力强，但是没有告警的功能，那么可以结合Prometheus在数据处理能力改善数据分析的展示。下面列了一些监控产品，但并不是严格按表格进行分类，比如Prometheus和Zabbix都有采集，展示，告警的功能。都可以了解一下，各取所长。

### 采集

cAdvisor, Heapster, collectd, Statsd, Tcollector, Scout

### 存储

InfluxDb, OpenTSDB, Elasticsearch

### 展示

Graphite, Grafana, facette, Cacti, Ganglia, DataDog

### 告警

Nagios, prometheus, Icinga, Zabbix
