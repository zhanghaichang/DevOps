## Telegraf Install

```
wget https://dl.influxdata.com/telegraf/releases/telegraf-1.6.3-1.x86_64.rpm

sudo yum localinstall telegraf-1.6.3-1.x86_64.rpm
```

## docker

docker pull telegraf

### 复制出配置文件

docker cp telegraf:/etc/telegraf/telegraf.conf ./telegraf

### docker run

docker run -d --name=telegraf -v /root/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf -v /var/run:/var/run telegraf
