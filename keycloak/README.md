# keycloak


docker 

```
docker network create keycloak-network

```


```
docker run --name mysql -d --net keycloak-network -e MYSQL_DATABASE=keycloak -e MYSQL_USER=keycloak -e MYSQL_PASSWORD=password -e MYSQL_ROOT_PASSWORD=root_password mysql
```

```
docker run --name keycloak --net keycloak-network jboss/keycloak:4.8.3.Fina
```
