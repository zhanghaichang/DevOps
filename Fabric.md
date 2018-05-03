
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
![http://fabric-chs.readthedocs.io/zh_CN/chs/tutorial.html](http://fabric-chs.readthedocs.io/zh_CN/chs/tutorial.html)
