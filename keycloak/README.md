# keycloak

Keycloak 是为现代应用系统和服务提供开源的鉴权和授权访问控制管理。Keycloak 实现了OpenID、OAuth2.0、SAML单点登录协议，同时提供 LDAP 和 Active Directory 以及 OpenID Connect、SAML2.0 IdPs、Github、Google 等第三方登录适配功能，能够做到非常简单的开箱即用。



docker 

```
docker network create keycloak-network

```


```
docker run -d --name postgres --net keycloak-network -e POSTGRES_DB=keycloak -e POSTGRES_USER=keycloak -e POSTGRES_PASSWORD=password postgres

```

```
docker run --name keycloak -p 443:443 -p 9990:9990 -p 8080:8080 --net keycloak-network  -d jboss/keycloak:4.8.3.Final
```


```
启动 docker

docker run –name openldap -p 389:389 -e LDAP_ORGANISATION=”my” -e LDAP_DOMAIN=”my.cn” -e LDAP_ADMIN_PASSWORD=”123456″ -e LDAP_TLS=false -d osixia/openldap:1.2.1

启动keycloak

docker run –name mysql_keycloak -d -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=keycloak -p 3336:3306 mysql:5.7
docker run –name keycloak -d -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=123456 -e DB_VENDOR=mysql -e DB_ADDR=***** -e DB_PORT=3336 -e DB_DATABASE=keycloak -e DB_USER=root -e DB_PASSWORD=123456 -p 8080:8080 jboss/keycloak

```
