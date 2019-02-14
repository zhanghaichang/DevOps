# LADP


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
