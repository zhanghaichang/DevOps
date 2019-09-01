# frp 内网穿透


### 2.开始安装

```
# 下载frp可执行包
wget https://github.com/fatedier/frp/releases/download/v0.27.0/frp_0.27.0_linux_amd64.tar.gz

# 解压
tar zxf frp_0.27.0_linux_amd64.tar.gz

# 进入文件
cd frp_0.27.0_linux_amd64/
# 修改配置
vi frps.ini 
# 内容如下：
[common]
# tunnel port通信管道
bind_port = 7000
# http和https
vhost_http_port = 80
vhost_https_port = 443
# 连接认证token
#token = 123456

# 子域名
subdomain_host = frp.kioye.cn

# 自定义404 页面，要用绝对路径哦！
custom_404_page = /root/frp_0.27.0_linux_amd64/404.html

# dashboard图形管理页面
dashboard_port = 81 

dashboard_user = admin
dashboard_pwd = admin

# ---设置完成----
# 启动
./frps -c frps.ini 

```
