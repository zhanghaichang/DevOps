# SaltStack
SaltStack是一个服务器基础架构集中化管理平台，具备配置管理、远程执行、监控等功能，一般可以理解为简化版的puppet和加强版的func。SaltStack基于Python语言实现，结合轻量级消息队列（ZeroMQ）与Python第三方模块（Pyzmq、PyCrypto、Pyjinjia2、python-msgpack和PyYAML等）构建。

通过部署SaltStack环境，我们可以在成千上万台服务器上做到批量执行命令，根据不同业务特性进行配置集中化管理、分发文件、采集服务器数据、操作系统基础及软件包管理等，SaltStack是运维人员提高工作效率、规范业务配置与操作的利器。


## 一、安装epel yum源
```
yum -y install epel-release 
yum clean all 
yum makecache
```


## 二、安装 saltstack-master 并配置
```
saltstack-master 安装： yum -y install salt-master

```


## 三、安装 saltstack-minion 并配置
```
saltstack-minion 安装： yum -y install salt-minion

vi /etc/salt/minion
# 设置salt-master服务
master: www.linuxprobe.com
# master 使用域名的话需要设置本机host解析
```
## 四、测试
```
salt-key -y -A

salt-key -L 

 salt "*" test.ping 
```
