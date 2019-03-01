# kong

Kong 的插件机制是其高可扩展性的根源，Kong 可以很方便地为路由和服务提供各种插件，网关所需要的基本特性，Kong 都如数支持：

* **云原生**: 与平台无关，Kong可以从裸机运行到Kubernetes

* **动态路由**：Kong 的背后是 OpenResty+Lua，所以从 OpenResty 继承了动态路由的特性

* **熔断**

* **健康检查**

* **日志**: 可以记录通过 Kong 的 HTTP，TCP，UDP 请求和响应。

* **鉴权**: 权限控制，IP 黑白名单，同样是 OpenResty 的特性

* **SSL**: Setup a Specific SSL Certificate for an underlying service or API.

* **监控**: Kong 提供了实时监控插件

* **认证**: 如数支持 HMAC, JWT, Basic, OAuth2.0 等常用协议

* **限流**

* **REST API**: 通过 Rest API 进行配置管理，从繁琐的配置文件中解放

* **可用性**: 天然支持分布式

* **高性能**: 背靠非阻塞通信的 nginx，性能自不用说

* **插件机制**: 提供众多开箱即用的插件，且有易于扩展的自定义插件接口，用户可以使用 Lua 自行开发插件


---------------
### Docker 安装


```
 $ docker network create kong-net
```

### Cassandra Database

```
 $ docker run -d --name kong-database \
               --network=kong-net \
               -p 9042:9042 \
               cassandra:3
```


### PostgreSQL  

```
 $ docker run -d --name kong-database \
               --network=kong-net \
               -p 5432:5432 \
               -e "POSTGRES_USER=kong" \
               -e "POSTGRES_DB=kong" \
               postgres:9.6
```
### 初始化数据

```
docker run --name kong --rm \
     --network=kong-net \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=kong-database" \
     -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
     kong:0.12 kong migrations up
     
```
## 安装
```
docker run -d --name kong \
--network=kong-net \
-e "KONG_DATABASE=postgres" \
-e "KONG_PG_HOST=kong-database" \
-e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
-e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
-e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
-e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
-e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
-e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
-e "KONG_ADMIN_LISTEN_SSL=0.0.0.0:8444" \
-p 8000:8000 \
-p 8443:8443 \
-p 8001:8001 \
-p 8444:8444 \
kong:0.12
```
## 建立连接

```
docker network connect kong-net kong
```
## 访问

```
 $ curl -i http://localhost:8001/
```
```
默认情况下，KONG监听的端口为：

　　· 8000：此端口是KONG用来监听来自客户端传入的HTTP请求，并将此请求转发到上有服务器；

　　· 8443：此端口是KONG用来监听来自客户端传入的HTTP请求的。它跟8000端口的功能类似，但是它只是用来监听HTTP请求的，没有转发功能。可以通过修改配置文件来禁止它；

　　· 8001：Admin API，通过此端口，管理者可以对KONG的监听服务进行配置；

　　· 8444：通过此端口，管理者可以对HTTP请求进行监控.
```
## Kong Dashboard

```
# Start Kong Dashboard
docker run --rm --network=kong-net -p 8080:8080 pgbi/kong-dashboard start --kong-url http://kong:8001

# Start Kong Dashboard on a custom port
docker run --rm -p [port]:8080 pgbi/kong-dashboard start --kong-url http://kong:8001

# Start Kong Dashboard with basic auth

docker run --rm --network=kong-net -p 8080:8080 pgbi/kong-dashboard start \
  --kong-url http://kong:8001 \
  --basic-auth user1=admin user2=admin

# See full list of start options
docker run --rm -p 8080:8080 pgbi/kong-dashboard start --help

```
## 访问

```
You can now browse Kong Dashboard at http://localhost:8080

```
# 接口注册kong

```
curl -i -X POST \
  --url  http://47.75.219.241:8001/apis/ \
  --data 'name=weather-api' \
  --data 'hosts=www.sojson.com' \
  --data 'upstream_url=https://www.sojson.com/open/api/weather/json.shtml'
  
```
