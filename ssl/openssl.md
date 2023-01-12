# Openssl 生成证书

```shell
# 生成根证书的私钥
openssl genrsa -out ca.key 4096

# 利用私钥生成一个根证书的申请
openssl req -new -key ca.key -out ca.csr

# 自签名的方式签发我们之前的申请的证书
openssl x509 -req -days 3650  -in ca.csr -signkey ca.key -out ca.crt

# 生成服务器验证证书的私钥
openssl genrsa -out server.key 4096

# 生成证书的申请文件
openssl req -new -key server.key -out server.csr

# 利用根证书签发服务器身份验证证书，(PEM格式)
openssl x509 -req -days 3650 -in server.csr -sha256 -CA ca.crt -CAkey ca.key -CAcreateserial -CAserial server.srl -out server.crt

```

X.509证书文件编码类型：

PEM：Base64编码的文本格式
DER：二进制文件
PEM 与 DER 文件之间可以使用如下命令进行转换：

```shell
# PEM 转换为 DER 文件
openssl x509 -inform PEM -outform DER -in server.crt -out server.der

# DER 转换为 PEM 文件
openssl x509 -inform DER -outform PEM -in server.der -out server.crt

```
