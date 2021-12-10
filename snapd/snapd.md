# 安装


安装 EPEL

 ```
yum install epel-release
```

安装 snapd

```
yum install snapd
```

添加snap启动通信 socket

```
systemctl enable --now snapd.socket
```

创建链接（snap软件包一般安装在/snap目录下）

```
ln -s /var/lib/snapd/snap /snap
```

参考文档

https://docs.snapcraft.io/installing-snap-on-centos/10020


常用命令

```shell
### 切换软件仓库
 
#扩展
snap refresh hugo --channel=extended 
 
#稳定
snap refresh hugo --channel=stable.
 
### 更新一个snap包，
如果你后面不加包的名字的话那就是更新所有的snap包
 
sudo snap refresh <snap name>
 
### 列出已经安装的snap包
 
sudo snap list
 
### 搜索要安装的snap包
 
sudo snap find <text to search>
 
### 安装一个snap包
 
sudo snap install <snap name>
 
### 把一个包还原到以前安装的版本
 
snap revert <snap name>
 
### 删除一个snap包
sudo snap remove <snap name>
```
