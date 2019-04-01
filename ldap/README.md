# LDAP

OpenLDAP 是一款轻量级目录访问协议（Lightweight Directory Access Protocol，LDAP），属于开源集中账号管理架构的实现，且支持众多系统版本，被广大互联网公司所采用。

LDAP 具有两个国家标准，分别是X.500 和LDAP。OpenLDAP 是基于X.500 标准的，而且去除了X.500 复杂的功能并且可以根据自我需求定制额外扩展功能，但与X.500 也有不同之处，例如OpenLDAP 支持TCP/IP 协议等，目前TCP/IP 是Internet 上访问互联网的协议。

OpenLDAP 则直接运行在更简单和更通用的TCP/IP 或其他可靠的传输协议层上，避免了在OSI会话层和表示层的开销，使连接的建立和包的处理更简单、更快，对于互联网和企业网应用更理想。LDAP 提供并实现目录服务的信息服务，目录服务是一种特殊的数据库系统，对于数据的读取、浏览、搜索有很好的效果。目录服务一般用来包含基于属性的描述性信息并支持精细复杂的过滤功能，但OpenLDAP 目录服务不支持通用数据库的大量更新操作所需要的复杂的事务管理或回滚策略等。




### LDAP特点

* LDAP的结构用树来表示
* 查询快，写慢
* LDAP提供了静态数据的快速查询方式
* Client/server模型，Server 用于存储数据，Client提供操作目录信息树的工具
* 这些工具可以将数据库的内容以文本格式（LDAP 数据交换格式，LDIF）呈现在您的面前
* LDAP是一种开放Internet标准，LDAP协议是跨平台的Interent协议


### LDAP简称对应

```
o：organization（组织-公司）
ou：organization unit（组织单元-部门）
c：countryName（国家）
dc：domainComponent（域名）
sn：suer name（真实名称）
cn：common name（常用名称）
```

[ldap](https://www.cnblogs.com/linuxws/p/9085641.html)
## phpldapadmin

```

docker run \
    --name phpldapadmin-service \
    --hostname phpldapadmin-service \
    --link ldap-service \
    #接入LDAP服务
    --env PHPLDAPADMIN_LDAP_HOSTS=ldap-service \
    #取消默认的https
    --env PHPLDAPADMIN_HTTPS=false \
    #web 映射虚拟端口 (自行修改)
    -p xxx:80 \
    --detach osixia/phpldapadmin:0.7.1
```


```
# 登陆用户
cn=admin,dc=example,dc=org
#搜索
ldapsearch -x -H ldap://localhost -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w admin
```
