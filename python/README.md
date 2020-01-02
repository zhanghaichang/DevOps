# python install

首先安装epel扩展源：

```
yum -y install epel-release
```

更新完成之后，就可安装pip：
```
yum -y install python-pip
```
安装完成之后清除cache：
```
yum clean all
```
安装epel-release和setuptools
```
yum makecache

yum install -y python34-setuptools　
```
安装pip3
```
easy_install-3.4 pip
```

 

## 对安装好的pip进行升级 pip install --upgrade pip

```
查看pip版本  pip-V
```
