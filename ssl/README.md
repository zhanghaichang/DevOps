# Let's Encrypt


```
./certbot-auto certonly --standalone --email zhang.hc@topcheer.com -d pydx.itophis.com
```
# 制作自签名泛域名证书

 预备工作：避免生成证书时 报错“ /etc/pki/CA/index.txt: No such file or directory ”

```
vim /etc/pki/tls/openssl.cnf 
```

 查到dir的目录，一般是/etc/pki/CA

```
cd /etc/pki/CA 
 ls
```
执行 
```
 touch index.txt 
 touch serial 
 echo "01" > serial
 ```
 
 1、生成CA的私钥 
``` 
openssl genrsa -des3 -out ca.key 2048 
```
 2、生成CA公钥 
```
openssl req -new -x509 -days 7305 -key ca.key -out ca.crt 
```
 三、制作网站的证书

1、生成证书私钥 

```
openssl genrsa -des3 -out *.sit.shrcb.pem 1024 
``` 

2、 将私钥解密生成key 
```
openssl rsa -in *.bigmen.cn.pem -out *.bigmen.cn.key
```
3、生成证书请求 

```
 openssl req -new -key *.bigmen.cn.pem -out *.bigmen.cn.csr
```
四、证书签名

【证书签名】 
```
 openssl ca -policy policy_anything -days 1460 -cert ca.crt -keyfile ca.key -in *.bigmen.cn.csr -out *.bigmen.cn.crt 
```
 证书期限1460天就是4年 

 连续输入两个y
