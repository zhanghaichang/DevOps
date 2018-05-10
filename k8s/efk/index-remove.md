查看所有的索引文件：
curl -XGET http://localhost:9200/_cat/indices?v

删除索引文件以释放空间：
curl -XDELETE http://localhost:9200/filebeat-2016.12.28

curl -u 'elastic:changeme' -XDELETE http://localhost:9200/*

单节点的elk可在索引目录删除索引文件:集群环境删除某节点的索引文件，会导致集群服务不可用.集群环境需要使用API的方式进行删除.

索引文件保留在服务器中，大大减小服务器的性能，占用硬盘空间，
因此使用脚本自动删除elk中两个月以前的索引以释放空间：

--#!/bin/bash

find '/data/elasticsearch/data/elks/nodes/0/indices/' -name 'filebeat-*' -ctime +60 > index.txt

cd ~
cat index.txt | while read line
do
curl -XDELETE "http://localhost:9200/"$(basename $line)""
done

添加计划任务：
$crontab -e
0 0 * * * cd /root && ./elk_index_remove.sh >>/dev/null
