# elasticsearch


```
docker run -p 9200:9200 --name elastic  -e "discovery.type=single-node" -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -e ES_JAVA_OPTS="-Xms1024m -Xmx1024m" -d docker.elastic.co/elasticsearch/elasticsearch:5.6.4
```
