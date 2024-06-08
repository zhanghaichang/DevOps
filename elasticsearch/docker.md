# elasticsearch


```
docker run -p 9200:9200 --name elastic  -e "discovery.type=single-node" -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -e ES_JAVA_OPTS="-Xms1024m -Xmx1024m" -d docker.elastic.co/elasticsearch/elasticsearch:5.6.4
```


### 删除deleteEsData.sh脚本

```shell
#!/bin/bash
# filename:deleteEsData.sh
# 每天2点定时删除es中指定日期的数据
# crontab: 0 2 * * * sh /home/scripts/deleteEsData.sh >> /home/scripts/logs/deleteEsData.run.log 2>&1
# 如今天是2017-09-21 50天前是2017.08.02
# createdate: 20190921

today=`date +%Y-%m-%d`;
echo "今天是${today}"

# 不指定参数时，默认删除daynum天前以logs-开头的数据
daynum=51

# 当参数个数大于1时，提示参数错误
if [ $# -gt 1 ] ;then
        echo "要么不传参数，要么只传1个参数!"
        exit 101;
fi

# 当参数个数为1时，获取指定的参数
if [ $# == 1 ] ;then
        daynum=$1
fi

esday=`date -d '-'"${daynum}"' day' +%Y.%m.%d`;
echo "${daynum}天前是${esday}"

curl -XDELETE http://127.0.0.1:9200/logs-${esday}
echo "${esday} 的log删除执行完成"


```
