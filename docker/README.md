## 通用参考和推荐

`docker build`命令使用Dockerfile或者上下文构建镜像，构建上下文是指定的本地路径或者URL的文件。本地路径是本地文件系统的目录，URL是本地的Git仓库。构建是由Docker守护进程运行的，而不是CLI。构建过程首先要做的就是把整个上下文**递归**的传给守护进程，强烈建议在一个空目录下进行构建过程。

*   容器应该是短暂的
*   使用一个.dokerignore文件
*   避免安装不必要的包
*   每个容器只运行一个进程
*   最小化层的数量
*   多行参数排序
*   建立缓存

## Dockerfile指令

格式：

```
# Commnet
INSTRUCTION arguments
```

INSTRUCTION（指令）大小写不敏感，但约定使用大写。

环境变量：

环境变量的格式可以是 `$variable_name` 或者 `${variable_name}`，`${variable:-word}`表示如果`variable`设置了，结果将是那个值，如果没有设置，则
结果是word；`${variable:+word}` 表示如果设置了variable，结果将是word，如果没有设置，则结果为空。

### FROM

```
FROM <image>
```

OR

```
FROM <image>:<tag>
```

OR

```
FROM <image>@<digest>
```

`FROM`指令为后面的指令设置基础镜像。一个有效的Dockerfile文件必须以`FROM`作为第一条非注释指令。

### MAINTAINER

```
MAINTAINER <name>
```

设置生成的镜像的`Author`字段

### RUN

`RUN`有两种格式：

*   `RUN <command>` shell格式，这个命令在shell中执行，Linux中默认是`/bin/sh -c`，windows系统默认是`cmd /S /C`
*   `RUN ["executable", "param1", "param2"]` exec格式

`RUN`指令将在当前镜像的新的一层执行任何命令并提交结果。

#### apt-get

避免执行`apt-get upgrade`和`dist-upgrade`，因为许多基础镜像中的必须包不会在特权容器中升级。

### CMD

`CMD`有三种格式：

*   `CMD ["executable", "param1", "param2"]` exec格式，首选的格式
*   `CMD ["param1", "param2"]` 作为ENTRYPOINT的默认参数
*   `CMD command param1 param2` shell格式

`CMD`的主要目的是为执行容器提供默认值。这些默认值可以包含可执行文件，或它们可以忽略可执行文件，在这种情况下，必须指定ENTRYPOINT指令。

当使用shell格式或exec格式时，`CMD`指令设置的命令将会在运行容器时执行。使用JSON数组声明一个命令是，必须使用执行文件的绝对路径。

```
FROM ubuntu
CMD ["/usr/bin/wc", "--help"]
```

在一个Dockerfile文件中只允许有一条`CMD`指令，如果有多条`CMD`指令，那么最后一条`CMD`指令生效。如果用户在执行`docker run`命令是指定了参数，那么将覆盖`CMD`指定的默认值。

**注意：** 

exec格式作为JSON数组的格式被解析，因此必须使用双引号将单词引起来，而不是单引号。

`RUN`和`CMD`的区别：`RUN`实际上在构建镜像过程中运行命令并提交结果；`CMD`在构建镜像过程中不执行任何操作，但指定了预执行命令（即在运行镜像时执行）。

### LABEL

`LABEL`执行是向镜像中添加元数据，一个`LABEL`是一个键值对，在`LABEL`的值中使用添加空格，使用双引号和反斜线。示例：

```
LABEL "com.example.vendor"="ACME Incorporated"
LABEL com.example.label-with-value="foo"
LABEL version="1.0"
LABEL description="This text illustrates \
that label-values can span multiple lines."
```

Docker可以指定多个标签，每个标签产生一个新层，多个层会导致效率低下，因此建议将多个标签合并到一个标签：

```
LABEL multi.label1="value1" multi.label2="value2" other="value3"
```

或：

```
LABEL multi.label1="value1" \
      multi.label2="value2" \
      other="value3"
```

查看镜像的`LABEL`可以使用`docker inspect`命令：

```
"Labels": {
    "com.example.vendor": "ACME Incorporated"
    "com.example.label-with-value": "foo",
    "version": "1.0",
    "description": "This text illustrates that label-values can span multiple lines.",
    "multi.label1": "value1",
    "multi.label2": "value2",
    "other": "value3"
},
```

### EXPOSE

```
EXPOSE <port> [<port>...]
```

`EXPOSE`指令通知Docker容器在运行时监听的端口。

### ENV

```
ENV <key> <value>
ENV <key>=<value> ...
```

`ENV`指令设置环境变量的值为。第二种格式可以设置多个键值对，推荐在一条`ENV`指令中设置多个键值对，因为这样产生一个缓存层。

### ADD

*   ADD …
*   ADD [“”,… “”] 对于包含空格的路径，使用这种格式

`ADD`指令复制新文件、目录或远程文件URL并添加他们到容器的文件系统路径，可以指定多个。每个可以包含通配符。

所有的新文件或目录使用UID和GID为0创建。如果是一个远程文件URL，目标将会是600的权限。如果远程文件有HTTP Last-Modified头，这个HTTP头部的时间戳将用于设置目标文件的mtime。

`ADD`指令遵循以下规则：

*   必须包含在构建的上下文中，不能使用`ADD ../something /something`。
*   如果是一个URL，不是以斜杠结束，文件将被从URL下载并拷贝到。
*   如果是一个URL，以斜杠结束，文件名将从URL中获取，文件被下载到/。例如：`ADD http://example.com/foobar /`将会创建文件/foobar。不能是[http://example.com](http://example.com)类的URL。
*   如果是目录，目录的所有内容将被复制，包括文件系统元数据（目录本身不复制，只是它的内容）。
*   如果是一个gzip,bzip2或者xz类型的压缩归档文件，文件将被作为一个目录解压。远程URL文件不会被解压。如果一个目录被复制或者解压，与`tar -x`的行为相同：结果唯一：
    1、无论在目标路径是否存在和
    2、源目录树的内容，冲突以逐个文件为基础解析为”2.”

**注意：** 文件是否被识别为识别的压缩格式仅基于文件的内容，而不是文件的文件名。例如：一个空文件以.tar.gz结尾，则不会被识别为压缩文件，并且不会生成任何解压缩错误消息，而是该文件将被文件简单的复制到目的地。

*   如果是其他类型的文件，它将于它的元数据一起单独的复制。在这种情况下，如果以`/`结尾，它将被认为是目录，的内容将被写在/base()。
*   如果指定了多个，无论是直接或使用通配符，必须是目录，并且以`/`结束。
*   如果不是以斜杠结束，将会被认作是一个常规文件，的内容将被写入。
*   如果不存在，所有在路径中不存在的目录将会被创建。

### COPY

*   `COPY <src>... <dest>`
*   `COPY ["<src>",... "<dest>"]` 路径中包含空格时需要这种格式

`COPY`指令从复制新文件文件或目录并添加它们到容器的文件系统路径。是一个绝对路径，或者相对`WORKDIR`的路径，其中源将被复制到目标容器内。

```
COPY test relativeDir/   # 添加 "test" 到 `WORKDIR`/relativeDir/
COPY test /absoluteDir/  # 添加 "test" 到 /absoluteDir/
```

所有的文件和目录以UID和GID 0 创建。

`COPY`遵循如下规则：

*   路径必须在构建的上下文中，不能使用`COPY ../something /something`
*   如果是一个目录，目录的所有内容包括元数据将会被复制。

**注意：** 目录本身不会被复制，只有它的内容。

*   如果是其他类型的文件，它将于它的元数据一起被单独复制。这种情况下，如果以斜杠`/`结束，它将会被认作是目录，的内容将被写在/base()。
*   如果指定了多个，或者直接或者使用通配符，必须是目录，且以`/`结束。
*   如果没有以斜杠结束，将会认作是一般文件，并且的内容将被写入。
*   如果不存在，所有在路径中不存在的目录将会被创建。

### ENTRYPOINT

*   `ENTRYPOINT ["executable", "param1", "param2"]` exec格式，推荐
*   `ENTRYPOINT command param1 param2` shell格式

`ENTRYPOINT`允许配置容器作为可执行文件运行。

例如，下面的例子将会以默认内容启动nginx，监听端口80：

```
docker run -i -t --rm -p 80:80 nginx
```

`docker run <image>`的命令行参数将附加在exec格式的ENTRYPOINT中的所有元素之后，并将覆盖使用CMD指令所有元素。这允许将参数传递到入口点，例如：`docker run <iamge> -d`将把-d参数传给入口点，可以使用–entrypoint标志覆盖ENTRYPOINT指令。

shell形式防止使用任何CMD或者运行命令行参数，但是缺点是ENTRYPOINT将作为/bin/sh -c的子命令启动，不传递信号。这意味着可执行文件将不是容器的PID 1，并且不接收Unix信号，因此您的可执行文件将不会从`docker stop <container>`接收到SIGTERM。

只有`Dockerfile`文件的最后一条`ENTRYPOINT`指令生效。

#### CMD和ENTRYPOINT是如何互相影响的

1、Dockerfile应该至少指定一个`CMD`或者`ENTRYPOINT`命令
2、当使用容器作为可执行文件使用时，应该定义`ENTRYPOINT`
3、`CMD`应该用作定义`ENTRYPOINT`命令的默认参数或在容器中执行ad-hoc命令的一种方法
4、当运行带有替代参数的容器时，`CMD`将被覆盖

下表显示了对不同ENTRYPOINT/CMD组合执行的命令：

| No ENTRYPOINT | ENTRYPOINT exec_entry p1_entry | ENTRYPOINT [“exec_entry”, “p1_entry”] |
| --- | --- | --- |
| No CMD | error,not allowed | /bin/sh -c exec_entry p1_entry |
| CMD [“exec_cmd”, “p1_cmd”] | exec_cmd p1_cmd | /bin/sh -c exec_entry p1_entry exec_cmd p1_cmd |
| CMD [“p1_cmd”, “p2_cmd”] | p1_cmd p2_cmd | /bin/sh -c exec_entry p1_entry p1_cmd p2_cmd |
| CMD exec_cmd p1_cmd | /bin/sh -c exec_ cmd p1_cmd | /bin/sh -c exec_entry p1_entry /bin/sh -c exec_cmd p1_cmd |

### VOLUME

```
VOLUME ["/data"]
```

`VOLUME`命令创建指定名称的挂载点，并将其标记为从本地主机或者其他容器保留外部挂载的卷。该值可以是JSON数组或者具有多个参数的纯字符串。

### USER

`USER daemon`

`USER`指令设置在运行镜像时使用的用户名或UID，以及Dockerfile中任何`RUN`，`CMD`，`ENTRYPOINT`指令的用户名。

### WORKDIR

```
WORKDIR /path/to/worddir
```

`WORKDIR`用来设置在`Dockerfile`文件中接下来的`RUN`，`CMD`，`ENTRYPOINT`，`COPY`和`ADD`等指令的工作目录。如果不存在，将会被创建，即使以后的Dockerfile指令都不使用。

## 通过Dockerfile创建镜像

### 制作Dockerfile文件

1、创建工程目录

```
$ mkdir mydockerbuilder
```

2、进入工程目录，创建Dockerfile

```
$ cd mydockerbuilder && touch Dockerfile
```

3、编写Dockerfile

```
$ vim Dockerfile

FROM docker/whaleasy:latest
RUN apt-get -y update && apt-get install -y fortunes
CMD /usr/games/fortune -a | cowsay

```

三行内容分别为：

指定基础镜像，即基于whaleasy:latest创建新镜像

更新镜像并安装fortunes引用程序

镜像加载后执行的命令

4、创建镜像

```
$ docker build -t docker-whale .
Sending build context to Docker daemon 2.048 kB
...snip...
Removing intermediate container a8e6faa88df3
Successfully built 7d9495d03763
```

### 镜像的创建过程

`docker build -t docker-whale .`命令使用当前目录下的Dockerfile文件制作一个叫`docker-whale`的镜像。制作过程中出现的信息含义如下：

首先Docker检查以确保它有它需要构建的一切。

```
Sending build context to Docker daemon 2.048 kB
```

然后Docker加载`whalesay:latest`镜像，如果本地没有，Docker将会下载此镜像。

```
Step 1 : FROM docker/whalesay:latest
 ---> fb434121fc77
```

接下来Docker使用apt-get包管理器更新包并安装`fortunes`

```
Step 2 : RUN apt-get -y update && apt-get install -y fortunes
 ---> Running in 27d224dfa5b2
Ign http://archive.ubuntu.com trusty InRelease
Ign http://archive.ubuntu.com trusty-updates InRelease
Ign http://archive.ubuntu.com trusty-security InRelease
Hit http://archive.ubuntu.com trusty Release.gpg
....snip...
Get:15 http://archive.ubuntu.com trusty-security/restricted amd64 Packages [14.8 kB]
Get:16 http://archive.ubuntu.com trusty-security/universe amd64 Packages [134 kB]
Reading package lists...
---> eb06e47a01d2

Reading package lists...
Building dependency tree...
Reading state information...
The following extra packages will be installed:
  fortune-mod fortunes-min librecode0
Suggested packages:
  x11-utils bsdmainutils
The following NEW packages will be installed:
  fortune-mod fortunes fortunes-min librecode0
0 upgraded, 4 newly installed, 0 to remove and 3 not upgraded.
Need to get 1961 kB of archives.
After this operation, 4817 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu/ trusty/main librecode0 amd64 3.6-21 [771 kB]
...snip......
Setting up fortunes (1:1.99.1-7) ...
Processing triggers for libc-bin (2.19-0ubuntu6.6) ...
 ---> c81071adeeb5
Removing intermediate container 23aa52c1897c
```

最后Docker完成构建并报告结果：

```
Step 3 : CMD /usr/games/fortune -a | cowsay
 ---> Running in a8e6faa88df3
 ---> 7d9495d03763
Removing intermediate container a8e6faa88df3
Successfully built 7d9495d03763
```
