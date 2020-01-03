# MinIO 

> 是一个基于Apache License v2.0开源协议的对象存储服务。它兼容亚马逊S3云存储服务接口，非常适合于存储大容量非结构化的数据，例如图片、视频、日志文件、备份数据和容器/虚拟机镜像等，而一个对象文件可以是任意大小，从几kb到最大5T不等。

MinIO是一个非常轻量的服务,可以很简单的和其他应用的结合，类似 NodeJS, Redis 或者 MySQL。

## 安装及部署Server

下载MinIO的Docker镜像：

```
docker pull minio/minio

```

在Docker容器中运行MinIO，这里我们将MiniIO的数据和配置文件夹挂在到宿主机上：

```
docker run -p 9090:9000 --name minio \
  -v /mydata/minio/data:/data \
  -v /mydata/minio/config:/root/.minio \
  -d minio/minio server /data

```

运行成功后，访问该地址来登录并使用MinIO，默认Access Key和Secret都是minioadmin：http://127.0.0.1:9090

## MinIO客户端

### 常用命令

<table>
<thead>
<tr>
<th>命令</th>
<th>作用</th>
</tr>
</thead>
<tbody>
<tr>
<td>ls</td>
<td>列出文件和文件夹</td>
</tr>
<tr>
<td>mb</td>
<td>创建一个存储桶或一个文件夹</td>
</tr>
<tr>
<td>cat</td>
<td>显示文件和对象内容</td>
</tr>
<tr>
<td>pipe</td>
<td>将一个STDIN重定向到一个对象或者文件或者STDOUT</td>
</tr>
<tr>
<td>share</td>
<td>生成用于共享的URL</td>
</tr>
<tr>
<td>cp</td>
<td>拷贝文件和对象</td>
</tr>
<tr>
<td>mirror</td>
<td>给存储桶和文件夹做镜像</td>
</tr>
<tr>
<td>find</td>
<td>基于参数查找文件</td>
</tr>
<tr>
<td>diff</td>
<td>对两个文件夹或者存储桶比较差异</td>
</tr>
<tr>
<td>rm</td>
<td>删除文件和对象</td>
</tr>
<tr>
<td>events</td>
<td>管理对象通知</td>
</tr>
<tr>
<td>watch</td>
<td>监听文件和对象的事件</td>
</tr>
<tr>
<td>policy</td>
<td>管理访问策略</td>
</tr>
<tr>
<td>session</td>
<td>为cp命令管理保存的会话</td>
</tr>
<tr>
<td>config</td>
<td>管理mc配置文件</td>
</tr>
<tr>
<td>update</td>
<td>检查软件更新</td>
</tr>
<tr>
<td>version</td>
<td>输出版本信息</td>
</tr>
</tbody>
</table>

### 安装及配置

下载MinIO Client 的Docker镜像：

```
docker pull minio/mc

```

在Docker容器中运行mc：

```
docker run -it --entrypoint=/bin/sh minio/mc

```

运行完成后我们需要进行配置，将我们自己的MinIO服务配置到客户端上去，配置的格式如下：

```
mc config host add <ALIAS> <YOUR-S3-ENDPOINT> <YOUR-ACCESS-KEY> <YOUR-SECRET-KEY> <API-SIGNATURE>

```

对于我们的MinIO服务可以这样配置：

```
mc config host add minio http://192.168.6.132:9090 minioadmin minioadmin S3v4
```

### 常用操作

查看存储桶和查看存储桶中存在的文件：

```
# 查看存储桶
mc ls minio
# 查看存储桶中存在的文件
mc ls minio/blog

```

创建一个名为test的存储桶：

```
mc mb minio/test

```

共享avatar.png文件的下载路径：

```
mc share download minio/blog/avatar.png

```

查找blog存储桶中的png文件：

```
mc find minio/blog --name "*.png"

```

设置test存储桶的访问权限为只读：

```
# 目前可以设置这四种权限：none, download, upload, public
mc policy set download minio/test/
# 查看存储桶当前权限
mc policy list minio/test/

```
