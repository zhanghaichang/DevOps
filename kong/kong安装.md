# centos搭建kong+konga

1.gcc

2.pcre

3.zlib

4.openssl

5.postgresql9.6+

6.konga


1.1安装 gcc 编译环境：

```
sudo yum install -y pcre pcre-devel

```

2.1 pcre 安装

```
sudo yum install -y pcre pcre-devel

```

3.1 zlib 安装

```
sudo yum install -y zlib zlib-devel

```

4.1 openssl 安装

```
sudo yum install -y openssl openssl-devel

```

5.1 postgresql 安装

kong持久化数据有postgresql和cassandra两种数据库选择 这里选择postgresql PS:不要图省事直接 yum install postgresql，因为这个版本比较低，kong不适用，至少要9.5+。

```
sudo yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-6-x86_64/pgdg-redhat-repo-42.0-11.noarch.rpm

yum install postgresql96-server

#初始化数据库

/usr/pgsql-9.6/bin/postgresql96-setup initdb

执行完毕显示：Initializing database ... OK

创建用户组和用户：

sudo groupadd postgresql

sudo useradd -gpostgresql postgresql

#实现开机自启服务
systemctl enable postgresql-9.6

#启动
service postgresql-9.6 start

```

5.2 postgresql配置

为kong创建用户以及数据库

```
// 新建 linux kong 用户 
sudo adduser kong

// 使用管理员账号登录 psql 创建用户和数据库
// 切换 postgres 用户
// 切换 postgres 用户后，提示符变成 `-bash-4.2$` 
su postgres

// 进入 psql 控制台
psql

// 此时会进入到控制台（系统提示符变为'postgres=#'）
// 先为管理员用户postgres修改密码
\password postgres

// 建立新的数据库用户（和之前建立的系统用户要重名）
create user kong with password '123456';

// 为新用户建立数据库
create database kong owner kong;

// 把新建的数据库权限赋予 kong
grant all privileges on database kong to kong;

// 退出控制台
\q

```

5.3 修改postgresql权限控制文件 pg_hba.conf

```
vi /var/lib/pgsql/9.6/data/pg_hba.conf

local   all             all                                     trust
host    all             all             0.0.0.0/0               md5
# IPv4 local connections:
host    all             all             127.0.0.1/32            ident
# IPv6 local connections:
host    all             all             ::1/128                 ident

```

5.4 修改postgresql文件postgresql.conf以开启远程访问

```
listen_addresses = '*'

```

6 kong安装

```
#kong一定要在1.0和1.3之间 不然konga不支持
curl -Lo kong-1.3.1.el7.amd64.rpm $( rpm --eval "https://download.konghq.com/gateway-1.x-centos-%{centos_ver}/Packages/k/kong-1.3.1.el%{centos_ver}.amd64.rpm")
$ sudo yum -y install kong-1.3.1.el7.amd64.rpm

```

6.1 修改kong配置文件


```
sudo cp /etc/kong/kong.conf.default /etc/kong/kong.conf
sudo vi /etc/kong/kong.conf

#------------------------------------------------------------------------------
# DATASTORE
#------------------------------------------------------------------------------

# Kong will store all of its data (such as APIs, consumers and plugins) in
# either Cassandra or PostgreSQL.
#
# All Kong nodes belonging to the same cluster must connect themselves to the
# same database.
admin_listen = 0.0.0.0:8001, 0.0.0.0:8444 ssl
database = postgres              # Determines which of PostgreSQL or Cassandra
                                 # this node will use as its datastore.
                                 # Accepted values are `postgres` and
                                 # `cassandra`.

pg_host = 127.0.0.1             # The PostgreSQL host to connect to.
pg_port = 5432                  # The port to connect to.
pg_user = kong                  # The username to authenticate if required.
pg_password = 123456            # The password to authenticate if required.
pg_database = kong              # The database name to connect to.

ssl = off                       # 如果不希望开放 8443 的 ssl 访问可关闭

```


```
#初始化kong数据库表
kong migrations up -c  /etc/kong/kong.conf
#启动
kong start
curl 127.0.0.1:8001

```

 yum 安装postgresql9.6遇到的坑及问题解决：

```
权限的问题，授权一下：
chmod 700 /var/lib/pgsql/9.6/data
```


7 开源项目konga

建议使用docker 如果对nodejs不熟悉 各种依赖很烦

```
#启动docker
systemctl start docker

docker pull pantsel/konga:latest

docker run --rm pantsel/konga:latest -c prepare -a postgres -u postgresql://kong:123456@118.31.12.176:5432/kong

docker run -d -p 1337:1337 \
             -e "DB_ADAPTER=postgres" \
             -e "DB_HOST=118.31.12.176" \
             -e "DB_PORT=5432" \
             -e "DB_USER=kong" \
             -e "DB_PASSWORD=123456" \
             -e "DB_DATABASE=kong" \
             -e "DB_PG_SCHEMA=public"\
             -e "NODE_ENV=production" \
             --name konga \
             pantsel/konga:latest

```
