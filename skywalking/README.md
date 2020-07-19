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

## 03 Java (Spring Boot)应用的接入
参考Skywalking Github：[Setup java agent](https://github.com/apache/incubator-skywalking/blob/master/docs/en/setup/service-agent/java-agent/README.md)

[@Trace注解的使用](https://github.com/apache/incubator-skywalking/blob/master/docs/en/setup/service-agent/java-agent/Application-toolkit-trace.md)

### 通过IDEA进行调试接入
- 更多agent 配置可以参考[agent config](https://github.com/apache/incubator-skywalking/blob/master/apm-sniffer/config/agent.config)
- vm options:

```bash
-javaagent:incubator-skywalking/skywalking-agent/skywalking-agent.jar
-Dskywalking.agent.application_code=hello-world-demo
-Dskywalking.collector.backend_service=localhost:11800
```

### 通过Jar包方式接入

```bash
java -javaagent:/apache-skywalking-apm-incubating/agent/skywalking-agent.jar -Dskywalking.collector.backend_service=localhost -Dskywalking.agent.application_code=hello-world-demo-0004 -jar target/sky-demo-1.0-SNAPSHOT.jar

```

### 通过容器接入
- Dockerfile

```bash
FROM openjdk:8-jre-alpine

LABEL maintainer="tanjian20150101@gmail.com"

ENV SW_APPLICATION_CODE=java-agent-demo \
	SW_COLLECTOR_SERVERS=localhost:11800

COPY skywalking-agent /apache-skywalking-apm-incubating/agent

COPY target/sky-demo-1.0-SNAPSHOT.jar /demo.jar

ENTRYPOINT java -javaagent:/apache-skywalking-apm-incubating/agent/skywalking-agent.jar -Dskywalking.collector.backend_service=${SW_COLLECTOR_SERVERS} \
-Dskywalking.agent.application_code=${SW_APPLICATION_CODE} -jar /demo.jar

```

- 构建并运行

```bash
docker build -t hello-demo .
docker run -p 10101:10101 -e SW_APPLICATION_CODE=hello-world-demo-005 -e SW_COLLECTOR_SERVERS=127.10.0.2:11800 hello-demo

```


