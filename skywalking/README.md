# Skywalking

Skywalking是一款国内开源的应用性能监控工具，支持对分布式系统的监控、跟踪和诊断。



SW总体可以分为四部分：

**1.Skywalking Agent：** 使用Javaagent做字节码植入，无侵入式的收集，并通过HTTP或者gRPC方式发送数据到Skywalking Collector。


**2. Skywalking Collector ：** 链路数据收集器，对agent传过来的数据进行整合分析处理并落入相关的数据存储中。

**3. Storage：** Skywalking的存储，时间更迭，sw已经开发迭代到了6.x版本，在6.x版本中支持以ElasticSearch、Mysql、TiDB、H2、作为存储介质进行数据存储。

**4. UI ：** Web可视化平台，用来展示落地的数据。


### Docker
```
docker run -d  -p 8080:8080 -p 10800:10800 -p 11800:11800 -p 12800:12800 \
-m 2048m --memory-swap 2400m \
-e JAVA_OPTS="-Xms1024m -Xmx2048m" \
-e ES_CLUSTER_NAME=elasticsearch \
-e ES_ADDRESSES=127.17.0.3:9300 \
wutang/skywalking-docker

```
