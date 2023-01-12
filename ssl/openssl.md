# Openssl 生成证书

* key【密钥/私钥 Private Key】是服务器上的私钥文件，用于对发送给客户端数据的加密，以及对从客户端接收到数据的解密
* csr【证书认证签名请求 Certificate signing request】是证书签名请求文件，用于提交给证书颁发机构（CA）对证书签名
* crt【证书 Certificate】是由证书颁发机构（CA）签名后的证书，或者是开发者自签名的证书，包含证书持有人的信息，持有人的公钥，以及签署者的签名等信息
* X.509 一种证书格式.对X.509证书来说，认证者总是CA或由CA指定的人，一份X.509证书是一些标准字段的集合，这些字段包含有关用户或设备及其相应公钥的信息。X.509的证书文件，一般以.crt结尾，根据该文件的内容编码格式，可以分为以下二种格式：
  - PEM - Privacy Enhanced Mail,打开看文本格式,以"-----BEGIN…"开头, "-----END…"结尾,内容是BASE64编码. Apache和*NIX服务器偏向于使用这种编码格式.
  - DER - Distinguished Encoding Rules,打开看是二进制格式,不可读.Java和Windows服务器偏向于使用这种编码格式
 
备注：在密码学中，X.509是一个标准，规范了公开秘钥认证、证书吊销列表、授权凭证、凭证路径验证算法等。

openssl 命令

```
-req 产生证书签发申请命令
-newkey 生成新私钥 rsa:4096 生成秘钥位数
-nodes 表示私钥不加密
-sha256 使用SHA-2哈希算法
-keyout 将新创建的私钥写入的文件名
-x509 签发X.509格式证书命令。X.509是最通用的一种签名证书格式。
-out 指定要写入的输出文件名
-subj 指定用户信息
-days 有效期（3650表示十年）
```
```shell
# 生成根证书的私钥 虚构一个CA认证机构
openssl genrsa -out ca.key 4096

# 利用私钥生成一个根证书的申请
openssl req -new -key ca.key -out ca.csr

# 自签名的方式签发我们之前的申请的证书 其实就是相当于用私钥生成公钥，再把公钥包装成证书
openssl x509 -req -days 3650  -in ca.csr -signkey ca.key -out ca.crt

# 生成服务器验证证书的私钥
openssl genrsa -out server.key 4096

# 生成证书的申请文件
openssl req -new -key server.key -out server.csr

# 利用根证书签发服务器身份验证证书，(PEM格式)
openssl x509 -req -days 3650 -in server.csr -sha256 -CA ca.crt -CAkey ca.key -CAcreateserial -CAserial server.srl -out server.crt

```

生成pem格式的公钥

有些服务，需要有pem格式的证书才能正常加载，可以用下面的命令：

```shell
openssl x509 -in server.crt -out server.pem -outform PEM
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


## 根据配置文件生成证书

1.生成key：

```shell
openssl genrsa -out D:\keys\cloudweb.key 4096
```

2.生成crs

```shell
openssl req -new -sha256 -out D:\keys\cloudweb.csr -key D:\keys\cloudweb.key -config ssl.conf 
```

3.查看crs

```shell
openssl req -text -noout -verify -in D:\keys\cloudweb.csr
```

4.CA机构为申请者生成crt

```shell
openssl x509 -req -days 3650 -in D:\keys\cloudweb.csr -signkey D:\keys\cagroup.key -out D:\keys\cloudweb.crt -extensions req_ext -extfile cassl.conf
```

5.查看crt

```shell
openssl x509 -in D:\keys\cloudweb.crt -text -noout

```
