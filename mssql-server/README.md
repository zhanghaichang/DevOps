# mssql-server-linux

1. 使用centos 7以上版本，从 Docker Hub 中拉出 SQL Server 2017 Linux 容器映像

```shell
$ sudo docker pull microsoft/mssql-server-linux:2017-latest
```
2. 运行一个镜像（也就相当于使用已有的镜像创建一个实例）

```shell
$ sudo docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=Sa123456!' -p 1433:1433 \
-v /data/msssql/:/var/opt/mssql \
--name msssql -d microsoft/mssql-server-linux:2017-latest
```

其中ACCEPT_EULA=Y的意思是同意许可协议，必选；MSSQL_SA_PASSWORD为密码，要求是最少8位的强密码，要有大写字母，小写字母，数字以及特殊符号，不然会有一个大坑（docker启动sqlserver容器后过几秒就停止了）；1433是docker内部SQLserver的端口。

3. 使用sqlcdm连接，这里插播一下sqlcmd的安装

首先下载yum的repo：
```
$ wget https://packages.microsoft.com/config/rhel/7/prod.repo
$ mv prod.repo /etc/yum.repos.d/
$ yum makecache
```
安装 mssql-tools
```
$ yum install mssql-tools
```
添加“/opt/mssql-tools/bin/”到PATH环境变量
```
#echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
#echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
#source ~/.bashrc  //立即生效
```

测试连接：
```
$ sqlcmd -S localhost -U SA -P 你设置的密码
```
