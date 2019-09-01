# ngrok  内网穿透


### 1、安装git

```shell
# 安装git
yum install git
```

### 2、安装GO语言环境

```shell
# 安装GO语言环境
yum install  golang
#检查下go的env环境变量
go env
```

### 3、下载ngrok

```shell
# github.com 下载 ngrok源码
cd /usr/local/ 
git clone https://github.com/inconshreveable/ngrok.git
```

### 4、生成证书

```shell
# 域名xxx.com 换成自己的
cd /usr/local/ngrok
openssl genrsa -out rootCA.key 2048  
openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=xxx.com" -days 5000 -out rootCA.pem  
openssl genrsa -out server.key 2048  
openssl req -new -key server.key -subj "/CN=xxx.com" -out server.csr  
openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 5000 
```
### 5、 拷贝证书覆盖ngrok原来的证书

```shell
# 过程会让你输入y 回车
cp rootCA.pem assets/client/tls/ngrokroot.crt 
cp server.crt assets/server/tls/snakeoil.crt 
cp server.key assets/server/tls/snakeoil.key

### 编译生成服务端
```
# 编译生成服务端
cd /usr/local/ngrok/  
GOOS=linux GOARCH=amd64 make release-server
```
### 编译生成客户端

```
# 32位linux客户端: 
GOOS=linux GOARCH=386 make release-client

# 64位linux客户端: 
GOOS=linux GOARCH=amd64 make release-client

#32位windows客户端: 
GOOS=windows GOARCH=386 make release-client

#64位windows客户端: 
GOOS=windows GOARCH=amd64 make release-client

#32位mac平台客户端:
GOOS=darwin GOARCH=386 make release-client

#64位mac平台客户端:
GOOS=darwin GOARCH=amd64 make release-client

#ARM平台linux客户端: 
GOOS=linux GOARCH=arm make release-client

# 生成客户端文件位置
/usr/local/ngrok/bin
```

### 启动服务器端

```
cd /usr/local/ngrok/bin

./ngrokd  -domain="xxx.com" -httpAddr=":800" -httpsAddr=":801" -tunnelAddr=":8443"

# 指定TLS证书和密钥
./ngrokd -tlsKey="/path/to/tls.key" -tlsCrt="/path/to/tls.crt" -domain="xxx.com" -httpAddr=":800" -httpsAddr=":801" -tunnelAddr=":8443"
```

### 客户端配置文件ngrok.yml

```
# 新建ngrok.yml
server_addr: xxx.com:8443
trust_host_root_certs: false
```

本地启动客户端
# 目录下打开命令行
# 然后使用以下任一命令运行ngrok：
ngrok -config ngrok.yml 8080
ngrok -config ngrok.yml -subdomain wx 8080 # 或者指定域名 wx.xxx.com

ngrok 加入系统服务 开机启动
vi /usr/lib/systemd/system/ngrok.service
# 在CentOS 7上利用systemctl添加自定义系统服务
[Unit]
Description=ngrok
After=network.target
 
[Service]
Type=simple  
Restart=always
RestartSec=1min
ExecStart=/usr/local/ngrok/bin/ngrokd   -domain=xqzgg.cn -httpAddr=:800 -httpsAddr=:801 -tunnelAddr=:8443 %i
ExecStop=/usr/bin/killall ngrok
PrivateTmp=true

[Install]
WantedBy=multi-user.target

# 重载系统服务：
systemctl daemon-reload

# 设置开机启动
systemctl enable ngrok.service

# 启动服务
systemctl start ngrok.service
常用命令
#设置开机启动：
systemctl enable ngrok.service
#启动服务：
systemctl start ngrok.service
#停止服务：
systemctl stop ngrok.service
附带一份 nginx.conf 配置文件
# ngrok
upstream ngrok {
	server 127.0.0.1:800;
	keepalive 64;
}

# ngrok 穿透
server {
	listen       80;
	server_name  *.xxx.com;

	location / {
		proxy_pass http://ngrok;
		proxy_redirect off;
		proxy_set_header Host $http_host:800;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
		expires 5s;
	}
}
