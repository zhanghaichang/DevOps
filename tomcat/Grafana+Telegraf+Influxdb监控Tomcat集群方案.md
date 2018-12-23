# Grafana+Telegraf+Influxdb监控Tomcat集群方案


## 监控预警系统，架构流程说明：

第一步：数据采集，Telegraf 采集 Tomcat 相关参数数据
第二步：数据存储，Influxdb 存储 Telegraf 采集的数据
第三步：数据可视化，Grafana 配置 Tomcat 监控面板

### Grafana
Grafana只是一个接入数据源的可视化面板，这里为了方便，我们选择Docker安装。

```
mkdir grafana
ID=$(id -u)
docker run -d --user $ID --name=grafana  --volume "$PWD/grafana:/var/lib/grafana" 
-p 3000:3000 grafana/grafana

# 如果生产环境配置，最好提前配置好域名
docker run -d --user $ID --name=grafana --volume "$PWD/data:/var/lib/grafana" \
-p 3000:3000 -e "GF_SERVER_ROOT_URL=http://monitor.52itstyle.com" grafana/grafana
```

查看容器相关参数：
```
docker inspect docker.io/grafana/grafana
```

Grafana的默认配置文件grafana.ini位于容器中的/etc/grafana，这个文件是映射不出来的。不过可以先创建并运行一个容器，拷贝出来重新创建运行容器。

参数说明(这里截取了部分重点参数)：

```
##################### Grafana 几个重要的参数(参考一下) #####################
[paths]
# 存放临时文件、session以及sqlite3数据库的目录
;data = /var/lib/grafana

# 存放日志的地方
;logs = /var/log/grafana

# 存放相关插件的地方
;plugins = /var/lib/grafana/plugins

#################################### Server ####################################
[server]
# 默认协议 支持(http, https, socket)
;protocol = http

# 默认端口
;http_port = 3000

# 这里配置访问地址，如果使用了反向代理请配置域名，发送告警通知的时候作为访问地址
root_url = http://grafana.52itstyle.com

#################################### Database ####################################
[database]

# 默认使用的数据库sqlite3，位于/var/lib/grafana目录下面
;path = grafana.db

#################################### Session ####################################
[session]
# session 存储方式，默认是file即可  Either "memory", "file", "redis", "mysql", "postgres", default is "file"
;provider = file

#################################### SMTP / Emailing ##########################
[smtp]
# 邮件服务器配置，自行修改配置
enabled = true
host = smtp.mxhichina.com:465
user = admin@52itstyle.com
# If the password contains # or ; you have to wrap it with trippel quotes. Ex """#password;"""
password = 123456
;cert_file =
;key_file =
;skip_verify = false
from_address = admin@52itstyle.com
# 这里不要设置中文，否则会发送失败
from_name = Grafana
```

### Influxdb

```
docker run -d -p 8083:8083 -p 8086:8086 -e ADMIN_USER="root" -e INFLUXDB_INIT_PWD="root" \
-e PRE_CREATE_DB="telegraf" --name influxdb tutum/influxdb:latest

```

如果出现influxdb运行容器说明安装成功。访问地址：http://ip:8083/

### Telegraf
```
docker pull telegraf
```
把telegraf相关配置拷贝到宿机
```
docker cp telegraf:/etc/telegraf/telegraf.conf ./telegraf
```

采集Tomcat数据：

如果想监控多个Tomcat，这里配置多个[[inputs.tomcat]]即可，但是一定要配置不同的tags标识。

```
[[inputs.tomcat]]
url = "http://192.168.1.190:8080/manager/status/all?XML=true"
# Tomcat访问账号密码 必须配置
username = "tomcat"
password = "tomcat"
timeout = "5s"
# 标识Tomcat名称、根据实际项目部署情况而定
[inputs.tomcat.tags]
host = "blog"

[[inputs.tomcat]]
url = "http://192.168.1.190:8081/manager/status/all?XML=true"
# Tomcat访问账号密码 必须配置
username = "tomcat"
password = "tomcat"
timeout = "5s"
# 标识Tomcat名称、根据实际项目部署情况而定
[inputs.tomcat.tags]
host = "bbs"
```

采集数据到influxdb

```
[[outputs.influxdb]]
      # urls = ["udp://localhost:8089"] # UDP endpoint example
      urls = ["http://localhost:8086"] # required，这个url改成自己host
      ## The target database for metrics (telegraf will create it if not exists).
      database = "telegraf" # 这个会在influx库创建一个库
```
把配置文件复制到容器：

```
docker cp telegraf.conf telegraf:/etc/telegraf/teleg
```
重启telegraf服务：
```
docker restart docker
```

### Tomcat
由于telegraf收集Tomcat相关数据需要配置访问权限，这里我们选择Tomcat7做配置说明。

修改位于conf下的tomcat-users.xml文件：
```
<tomcat-users>
<user username="tomcat" password="tomcat" roles="manager-gui,manager-script,manager-jmx,manager-status"/>
</tomcat-users>
```
重启Tomcat容器，访问以下地址：
```
http://ip:8080/manager/status/all?XML=true
```
