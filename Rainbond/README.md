# Rainbond



## 1.2 下载系统安装工具

https://www.rainbond.com/docs/user-operations/install/online_install/


## 安装


```
# 建议使用root执行安装操作
wget https://pkg.rainbond.com/releases/common/v5.1/grctl
chmod +x ./grctl

## 第一个节点管理节点和计算节点复用
./grctl init --iip <内网ip> --eip <弹性ip/所在公网ip/slb ip> --role master,compute --storage nas 

```
