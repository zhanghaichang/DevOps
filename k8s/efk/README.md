# EFK install


### Docker 日志格式

> vim /etc/sysconfig/docker

修改 --log-driver=json-file 

重启docker服务： service docker restart即可


docker run -p 9200:9200 --name elastic -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -d docker.elastic.co/elasticsearch/elasticsearch:5.6.4

docker run -p 5601:5601 -e "ELASTICSEARCH_URL=http://localhost:9200" --name my-kibana --network host -d docker.elastic.co/kibana/kibana:5.6.4


### elasticsearch启动时遇到的错误

问题翻译过来就是：elasticsearch用户拥有的内存权限太小，至少需要262144；


解决：

切换到root用户

执行命令：
```
sysctl -w vm.max_map_count=262144
```
查看结果：
```
sysctl -a|grep vm.max_map_count
```
显示：
```
vm.max_map_count = 262144
```
 

上述方法修改之后，如果重启虚拟机将失效，所以：

解决办法：

在   /etc/sysctl.conf文件最后添加一行
```
vm.max_map_count=262144
```
即可永久修改


setenforce 0

cat /etc/selinux/config  
永久关闭,可以修改配置文件/etc/selinux/config,将其中SELINUX设置为disabled，如下，
SELINUX=disabled  

```
 <match **>
      @id elasticsearch
      @type elasticsearch_dynamic
      @log_level info
      include_tag_key true
      host 172.16.150.6
      port 9200
      user elastic
      password changeme
      logstash_format true
      # Set type name dynamically
      logstash_prefix k8s-${record['kubernetes']['namespace_name']}-${record['kubernetes']['container_name']}
      <buffer>
        @type file
        path /var/log/fluentd-buffers/kubernetes.system.buffer
        flush_mode interval
        retry_type exponential_backoff
        flush_thread_count 2
        flush_interval 5s
        retry_forever
        retry_max_interval 30
        chunk_limit_size 2M
        queue_limit_length 8
        overflow_action block
      </buffer>
```

# Lable
kubectl get nodes --show-labels

# Node 节点打标签
$ kubectl label node node0.localdomain beta.kubernetes.io/fluentd-ds-ready=true 
# 重新运行 fluentd
$ kubectl apply -f fluentd-es-ds.yaml
# 查看 Pod 是否启动成功
$ kubectl get pods -n kube-system
