# phpMyadmin

是一个被普遍应用的网络数据库管理系统，使用起来较为简单，可以自动创建，也可以运行SQL语句创建


```
docker run --name myadmin -d --link mysql_db_server:db -p 8080:80 -v /some/local/directory/config.user.inc.php:/etc/phpmyadmin/config.user.inc.php phpmyadmin/phpmyadmin
```

您可以在PMA_HOST环境变量中指定MySQL主机。您还可以使用它PMA_PORT来指定服务器的端口，以防它不是默认端口：

```
docker run --name myadmin -d -e PMA_HOST=dbhost -p 8080:80 phpmyadmin/phpmyadmin
```

### 环境变量摘要
```

PMA_ARBITRARY - 当设置为1时，将允许任意服务器连接
PMA_HOST - 定义MySQL服务器的地址/主机名
PMA_VERBOSE - 定义MySQL服务器的详细名称
PMA_PORT - 定义MySQL服务器的端口
PMA_HOSTS - 定义逗号分隔的MySQL服务器的地址/主机名列表
PMA_VERBOSES - 定义以逗号分隔的MySQL服务器详细名称列表
PMA_PORTS - 定义以逗号分隔的MySQL服务器端口列表
PMA_USER和PMA_PASSWORD- 定义用于配置身份验证方法的用户名
PMA_ABSOLUTE_URI - 定义面向用户的URI

```
