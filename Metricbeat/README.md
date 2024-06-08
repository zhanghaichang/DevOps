# Metricbeat 入门简介

## 一、什么是 Metricbeat？

Metricbeat 是一款轻量级的指标采集工具，专注于从系统及各类服务中高效收集性能指标数据。它能够以极小的资源开销，全面覆盖从基础的 CPU、内存监测到复杂的如 Redis、Nginx 等服务的统计信息收集，并将这些数据定期发送至 Elasticsearch 存储，为用户提供实时的分析与监控能力。

## 二、Metricbeat 组成

Metricbeat 主要由两大部分构成：

### Module

- **功能说明**：Module 负责定义数据收集的目标实体，即需要监控的具体系统或服务，例如 MySQL 数据库、Redis 缓存服务、Nginx Web 服务器乃至整个操作系统。

### Metricset

- **功能说明**：Metricset 是一组具体的度量指标集合，每个 Module 下可以包含多个 Metricset，它们定义了从目标中具体提取哪些指标数据，例如在 `system` Module 下，可能有 `cpu`、`memory`、`network` 等不同的 Metricset 分别对应收集 CPU 使用率、内存使用情况和网络流量等信息。

# 三、部署Metricbeat与收集指标

## 3.1、下载

```shell
[root@node1 app]# wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.5.4-linux-x86_64.tar.gz
```

## 3.2、安装

```shell
[root@node1 app]# tar -zxvf metricbeat-6.5.4-linux-x86_64.tar.gz
[root@node1 app]# mv metricbeat-6.5.4-linux-x86_64 metricbeat
```

## 3.3、更改配置文件

```shell
[root@node1 metricbeat]# cd metricbeat
[root@node1 metricbeat]# vim metricbeat.yml
```

- 在第94行，设置Elasticsearch集群的IP地址：

```yaml
hosts: ["192.168.1.111","192.168.1.112","192.168.1.113"]
```

- 默认模块配置位于 `${path.config}/modules.d/*.yml`，如 `cd modules.d/`。

  ```shell
[root@node1 metricbeat]# ./metricbeat -e
  ```

## 3.5、页面查看
- 可见新增了一个名为 `metricbeat-6.5.4-2020.12.06` 的库。

## 3.6、system module配置


```yaml
module: system period: 10s # 采集频率，每10秒一次 metricsets:
cpu
load
memory
network
process
process_summary
```

# 四、Metricbeat Module

## 4.1、查看Module列表

```shell
[root@node1 metricbeat]# ./metricbeat modules list Enabled: system
Disabled: ...
```

## 4.2、开启Nginx Module
- 配置Nginx以启用状态查询：

```shell
[root@node1 nginx-1.10.1]# ./configure --prefix=/usr/local/nginx --with-http_stub_status_module
[root@node1 nginx-1.10.1]# make && make install
```
 -修改Nginx配置文件 `conf/nginx.conf` 添加如下内容：

```shell
nginx location /nginx-status { stub_status on; access_log off; }
```

- 重启Nginx：

```
[root@node1 nginx]# sbin/nginx -s reload
```


- 访问 `http://192.168.1.129/nginx-status` 查看状态。

## 4.3、配置Metricbeat的nginx module
- 启用nginx module：

```shell
[root@node1 metricbeat]# ./metricbeat modules enable nginx
Enabled nginx
```
 
修改 `modules.d/nginx.yml` 文件：

```shell
module: nginx period: 10s hosts: ["http://192.168.1.129"] server_status_path: "nginx-status"
```

## 4.4、启动

```sehll
 ./metricbeat -e
```
