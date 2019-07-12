# PostgreSQL admin 4

1.创建并运行postgre admin 4容器

```
docker run -d -p 8009:80 \
--network=kong-net \
--link kong-database:kong-database \
-e "PGADMIN_DEFAULT_EMAIL=admin@admin.com" \
-e "PGADMIN_DEFAULT_PASSWORD=admin@admin.com" \
-d dpage/pgadmin4
```
2. 然后访问 http://192.168.33.10:8009

登录账号为admin@admin.com，密码为admin@admin.com
