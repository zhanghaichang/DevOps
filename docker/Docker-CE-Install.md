# docker ce

### 安装源
```
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

### 查询docker 版本
```
yum list docker-ce.x86_64  --showduplicates |sort -r
```

### 安装
```
yum makecache fast

yum install -y --setopt=obsoletes=0 \
  docker-ce-17.03.2.ce-1.el7.centos \
  docker-ce-selinux-17.03.2.ce-1.el7.centos
```

### 启动
```
systemctl start docker
systemctl enable docker
```
