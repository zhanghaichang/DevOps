# Tenine
> 　Tengine是由淘宝网发起的Web服务器项目。它在Nginx的基础上，针对大访问量网站的需求，添加了很多高级功能和特性。Tengine的性能和稳定性已经在大型的网站如淘宝网，天猫商城等得到了很好的检验。它的最终目标是打造一个高效、稳定、安全、易用的Web平台。 从2011年12月开始，Tengine成为一个开源项目，Tengine团队在积极地开发和维护着它。Tengine团队的核心成员来自于淘宝、搜狗等互联网企业。官网地址：http://tengine.taobao.org/

#### 下载地址:
http://tengine.taobao.org/download.html

#### 安装tengine前安装好c语言编译工具
```shell
yum install gcc openssl-devel pcre-devel zlib-devel -y
```

#### 解压tengine

```shell
tar -zxvf tengine-3.1.0.tar.gz
```

#### 编译和安装软件
```
$ ./configure
$ make
$ sudo make install
```

#### 启动

```shell
/usr/local/nginx/sbin/nginx
```

#### 通过进程查看Nginx是否启动成功

```shell
ps -ef | grep nginx
```

#### 有序停止

```shell
/usr/local/tengine/sbin/nginx -s quit
```
