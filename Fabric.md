
## 简介 fabric

是一个python的库，fabric可以通过ssh批量管理服务器。

> yum install -y gcc python-devel python-pip openssl-devel

### pip 是一个Python计算机程序语言写成的软件包管理系统，它可以安装和管理软件包，没有python-pip包就执行命令

> yum -y install epel-release

> yum install python-pip

>  pip install --upgrade pip

### 如果还是不行就手工装 pip工具安装 Centos7，

> wget https://bootstrap.pypa.io/get-pip.py

> python get-pip.py

> pip --version

## 安装fabric

> pip install fabric

python -c "from fabric.api import * ; print env.version"

显示出版本说明安装成功

### 简单使用

编写fabfile;

vim host_type.py

```
from fabric.api import run
def host_type():
    run('uname -s')
```
使用fab 在本地执行刚才定义的host_type

```
# fab -f host_type.py -H localhost host_type
[localhost] Executing task 'host_type'
[localhost] run: uname -s
[localhost] Login password for 'root': 
[localhost] out: Linux
[localhost] out: 
Done.
Disconnecting from localhost... done.
```

至此fabric简单安装及使用到此为止

fabric好用之处就是你可以编写fabfiles 重复利用。  

## Fabric的使用

**一. Hello, Fabric**
首先用`vim fabfile.py`创建一个名为**fabfile.py**的文件,文件内容如下：

```
def hello(): 
  print("Hello world!")

```

`wq`退出保存后，我们就可以用fab工具来执行这个hello函数，输入命令

```
fab hello

```

<div class="image-package">

<div class="image-caption">运行结果，显示Hello world!</div>

</div>

> fab工具默认导入当前目录的 fabfile文件， 并执行了命令指定的函数，你能在 fabfile 中完成任何普通 Python 模块中可以做的事情。

**二. fab 命令的常用参数**

```
fab --help  #显示fab的参数和作用
fab -l      # 显示可用的task（命令）
fab -H      # 指定host，支持多个host，以逗号分开
fab -R      # 指定role，支持多个role
fab -P      # 并发数，默认串行
fab -w      # warn_only，默认遇到异常直接abort退出
fab -f      # 指定入口文件，默认fabfile.py

```

**三. Fabric的常用函数**

1.  lcd() 切换本地目录
    lcd("/var/www") #打开本地/var/www目录

2.  cd() 切换远程目录
    cd("/var/www") #打开远程/var/www目录

3.  local() 执行本地命令
    local("ls") #在本地执行ls命令，显示本地目录文件

4.  run() 执行远程命令
    run("ls") #在远程执行ls命令，显示远程目录文件

5.  sudo() 执行远程sudo
    sudo("service httpd stop") #远程服务器用sudo停止httpd服务

6.  put() 从本地上传文件到远端
    put('bin/project.zip', '/tmp/project.zip') #本地目录文件上传到远端

7.  其他实用工具函数

    ```
    #终止执行，向 stderr 输入错误信息 msg并退出
    fabric.utils.abort(msg)  

    #给定错误信息 message 以调用 func
    fabric.utils.error(message, func=None, exception=None, stdout=None, stderr=None) 

    #打印警告信息，但不退出执行。
    fabric.utils.warn(msg) 

    #彩色输出的函数 需要引用from fabric.colors import red, green
    print(red("This sentence is red, except for " + green("these words, which are green") + "."))

    #询问用户 yes/no 的问题，并将用户输入转换为 True 或 False。
    fabric.contrib.console.confirm(question, default=True)

    ```

**四. 异常处理**
官方推荐使用环境字典的settings的warn_only, 具体代码如下:

```
from __future__ import with_statement
from fabric.api import settings, abort
from fabric.contrib.console import confirm
from fabric.operations import put

def put_task():  
  run("mkdir -p /data/logs")  
  with cd("/data/logs"):  
    with settings(warn_only=True):  
        result = put("/data/logs/access.tar.gz", "/data/logs/access.tar.gz")  
    if result.failed and not confirm("put file failed, Continue[Y/N]?"):  
        abort("Aborting file put task!") 

```

> 1 环境字典中的warn_only 默认为False，指定在 run、sudo、local遇到错误时究竟是警告还是退出。
> 2 put这样运行命令的操作会返回一个包含执行结果（ .failed或 .return_code属性）的对象。

3 Fabric contrib.console子模块提供了 confirm函数，用于简单的 yes/no 提示。
4 abort函数用于手动停止任务的执行。

**五. 环境字典**

> **环境字典** fabric.state.env是作为全局单例实现的，为方便使用也包含在fabric.api中。 env中的键通常也被称为“环境变量”。

**几个常用的环境变量：**

1.  **user **：Fabric 在建立 SSH 连接时默认使用本地用户名，必要情况下可以通过修改env.user来设置。
2.  **password** ：用来显式设置默认连接或者在需要的时候提供 sudo 密码。如果没有设置密码或密码错误，Fabric 将会提示你输入。
3.  **warn_only** : 布尔值，用来设置 Fabric 是否在检测到远程错误时退出。
4.  **hosts** ：组合任务对应主机列表时会包含的全局主机列表。
5.  **roledefs** ：定义角色名和主机列表的映射字典。
6.  **roles** ：按任务足额和主机列表时使用的全局任务列表。

**settings会话管理器,临时修改环境变量**

```
from fabric.api import settings, run
 def exists(path): 
    with settings(warn_only=True):  #临时修改warn_only为true
      return run('test -e %s' % path)

```

**六. Fabric的注解**

1.  parallel并行注解，代码如下：

    ```
    from fabric.api import *
    @parallel
    def runs_in_parallel():
      pass
    def runs_serially(): 
      pass

    ```

    如果这样执行：

    ```
    fab -H host1,host2,host3 runs_in_parallel runs_serially

    ```

将会按照这样的流程执行：

> runs_in_parallel在 host1、host2和 host3上并行运行
> runs_serially在 host1、host2和host3上串行运行

1.  serial串行注解，代码如下：

    ```
    from fabric.api import *

    def runs_in_parallel():
      pass
    @serial
    def runs_serially(): 
      pass

    ```

如果这样执行：

```
   fab -H host1,host2,host3 -P runs_in_parallel runs_serially

```

> 命令行增加选项 [-P]制所有任务并行执行，但是runs_serially()函数以为增加了串行注解，依然会串行执行

**七. 最后举个栗子**

```
#! /usr/bin/env python
# coding:utf-8

from fabric.api import *

env.user='root'  
env.hosts=['192.168.1.21','tyiman@192.168.1.22','192.168.1.23']  

env.roledefs = {
  'node_agent': ['192.168.1.21']
  'node_monitor': ['tyiman@192.168.1.22','192.168.1.23']
}

env.passwords = {
  'root@192.168.1.21': 'password1',
  'tyiman@192.168.1.22': 'password2',
  'root@192.168.1.23': 'password3'
}
def test():
  with settings(warn_only=True):
    result = put("/data/logs/access.tar.gz","/data/logs/access.tar.gz")
    print("put the file to the remote success")
if result.failed and not confirm("Put file failed. Continue anyway?"):
    abort("Aborting at user request.")

def deploy():
  test()
  local("git add -p && git commit")
  local("git push")

@task
@parallel
@roles('node_agent')
  def nginx_start():
  sudo('/etc/init.d/nginx start')

@task
@serial
@roles('node_agent')
  def nginx_stop():
  sudo('/etc/init.d/nginx stop')

@task
@parallel(pool_size=5)
@roles('node_monitor')
def mysql_start()
    sudo('/etc/init.d/mysql start')
```

[官方中文说明文档](http://fabric-chs.readthedocs.io/zh_CN/chs/tutorial.html)
