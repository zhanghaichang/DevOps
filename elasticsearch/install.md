# Elasticsearch 6.2.4 安装步骤 (Linux)

## 环境准备
1. **Java环境**: 确保安装 Java 8 或更高版本（不推荐 Java 9）。通过 `java -version` 验证。
2. **系统用户**: 建议使用非 root 用户，如创建用户 `elasticsearch`。

## 下载 Elasticsearch

```shell
bash wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.4.tar.gz
```

## 3. 解压缩
将下载的文件解压缩到 `/opt` 目录：

```shell
 sudo tar -xzf elasticsearch-6.2.4.tar.gz -C /opt
```
## 4. 配置 Elasticsearch
- 进入配置目录：`/opt/elasticsearch-6.2.4/config`
- 修改 `elasticsearch.yml` 文件：
   - 集群名称（默认 `elasticsearch`）
   - 节点名称（每个节点应唯一）
   - 网络设置（确保绑定正确地址）
   - 堆内存大小（调整 `Xms` 和 `Xmx`）
```yaml
集群名称
cluster.name: my-application
节点名称
node.name: node-1
网络绑定
network.host: 192.168.1.10
堆内存设置
heap.size: 10g
```

## 5. 权限与系统服务设置
- 赋予 Elasticsearch 文件和目录适当的权限。
- （可选）创建一个系统服务，例如使用 `systemd`。

## 6. 启动 Elasticsearch
### 或者手动启动

```shell
cd /opt/elasticsearch-6.2.4/bin
./elasticsearch -d
```
## 7. 验证安装
- 在浏览器中访问 `http://your_server_ip:9200`。
- 使用 `curl` 命令验证：

```shell
curl -X GET "http://localhost:9200"
```
