# keycloak


docker 

```
docker network create keycloak-network

```


```
docker run --name mysql -d --net keycloak-network -e MYSQL_DATABASE=keycloak -e MYSQL_USER=keycloak -e MYSQL_PASSWORD=password -e MYSQL_ROOT_PASSWORD=root_password mysql
```

```
docker run --name keycloak -p 443:443 -p 9990:9990 -p 8080:8080 --net keycloak-network jboss/keycloak:4.8.3.Final
```
