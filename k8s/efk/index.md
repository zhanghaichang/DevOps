# EFK install

docker run -p 9200:9200 --name elastic -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -d docker.elastic.co/elasticsearch/elasticsearch:5.6.4

docker run -p 5601:5601 -e "ELASTICSEARCH_URL=http://localhost:9200" --name my-kibana --network host -d docker.elastic.co/kibana/kibana:5.6.4


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
