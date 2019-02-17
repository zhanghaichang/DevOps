# keycloak


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
