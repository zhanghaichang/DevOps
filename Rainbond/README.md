
# Rainbond



## 1.2 下载系统安装工具

https://www.rainbond.com/docs/user-operations/install/online_install/


## 安装


```shell
# 建议使用root执行安装操作
wget https://pkg.rainbond.com/releases/common/v5.1/grctl
chmod +x ./grctl

## 第一个节点管理节点和计算节点复用
./grctl init --iip <内网ip> --eip <弹性ip/所在公网ip/slb ip> --role master,compute --storage nas 


## 第一个节点仅作为管理节点
./grctl init --iip <内网ip> --eip <弹性ip/lb所在公网ip/slb ip> --role master --storage nas --storage-args "goodrain-rainbond.cn-huhehaote.nas.aliyuncs.com:/ /grdata nfs vers=3,nolock,noatime 0 0"

```

## 添加节点

```shell
# 添加管理节点
grctl node add --host <managexx> --iip <管理节点内网ip> -p <root密码> --role master 
## 法2默认已经配置ssh信任登陆
grctl node add --host  <managexx>  --iip <管理节点内网ip> --key /root/.ssh/id_rsa.pub --role master

# 添加计算节点
grctl node add --host <computexx> --iip <计算节点内网ip> -p <root密码> --role compute
## 法2默认已经配置ssh信任登陆
grctl node add --host <computexx> --iip <计算节点内网ip> --key /root/.ssh/id_rsa.pub --role compute

# 安装节点，节点uid可以通过grctl node list获取
grctl node install <新增节点uid> 

# 确定计算节点处于非unhealth状态下，可以上线节点
grctl node up <新增节点uid>
```

## 确定集群状态

```
grctl cluster
```


## 访问

```
http://localhost:7070
```
