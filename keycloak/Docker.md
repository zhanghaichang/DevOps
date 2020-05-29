# Keycloak服务安装及配置

安装Keycloak

Keycloak安装有多种方式，这里使用Docker进行快速安装

```
docker run -d --name keycloak \
    -p 8080:8080 \
    -e KEYCLOAK_USER=admin \
    -e KEYCLOAK_PASSWORD=admin \
    jboss/keycloak:10.0.0

```

访问http://localhost:8080并点击Administration Console进行登录
