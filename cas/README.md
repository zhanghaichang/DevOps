# CAS

Central Authentication Service (CAS)，通常称为CAS。 CAS是一种针对Web的企业多语言单点登录解决方案，并尝试成为您的身份验证和授权需求的综合平台。


### CAS Server

CAS Server 需要独立部署，主要负责对用户的认证工作， 它会处理用户名 / 密码等凭证 (Credentials) ；
CAS Server 负责完成对用户的认证工作， CAS Server 需要独立部署，有不止一种 CAS Server 的实现， Yale CAS Server 和 ESUP CAS Server 都是很不错的选择。
CAS Server 会处理用户名 / 密码等凭证 (Credentials) ，它可能会到数据库检索一条用户帐号信息，也可能在 XML 文件中检索用户密码，对这种方式， CAS 均提供一种灵活但同一的接口 / 实现分离的方式， CAS 究竟是用何种认证方式，跟 CAS 协议是分离的，也就是，这个认证的实现细节可以自己定制和扩展。



### 安装及部署

```
官网下载地址:
https://github.com/apereo/cas-overlay-template
```
生成证书，用jdk的keytool

```
#生成证书保存到D盘的keystore
keytool -genkey -alias tomcat  -keyalg RSA -keysize 1024 -validity 36500 -keystore D:/mycas/tomcat.keystore 
#生成证书的时候，记住cas的域名必须保持一致,存放路径可以自行选择
```

导出证书

```
#导出证书tomcat.cer,证书生成在 D盘
keytool -export -trustcacerts -alias tomcat -file D:/mycas/tomcat.cer -keystore D:/mycas/tomcat.keystore
```
将证书导入到jdk的目录

```
keytool -import -trustcacerts -alias tomcat -file D:/mycas/tomcat.cer -keystore "C:/Program Files/Java/jdk1.8.0_161/jre/lib/security/cacerts" -storepass    changeit
#自行选择自己的证书路径和jdk路径
```
查看jdk目录下的证书


编译war包

```

#官网下载地址
https://oss.sonatype.org/content/repositories/releases/org/apereo/cas/cas-server-webapp-tomcat/

#个人下载地址（这个是依赖包）
http://yellowcong.qiniudn.com/cas-server-webapp-tomcat-5.2.0.war

#安装war包到maven本地仓库
-Dfile 是需要上传到本地仓库的文件
mvn install:install-file -Dfile=D:/mycas/cas-server-webapp-tomcat-5.2.3.war -DgroupId=org.apereo.cas  -DartifactId=cas-server-webapp-tomcat  -Dversion=5.2.3 -Dpackaging=war

```
配置tomcat

```
#tomcat版本要8以上
#tomcat8.5下载地址
http://mirrors.shuosc.org/apache/tomcat/tomcat-8/v8.5.29/bin/
```
配置server.xml
配置8443端口

```xml
<!--设定http/1.1协议 还有配置keystore的位置和密码-->
<Connector port="8443" protocol="HTTP/1.1"  
               minSpareThreads="5" maxSpareThreads="75"    
               enableLookups="true" disableUploadTimeout="true"      
               acceptCount="100"  maxThreads="200"    
               scheme="https" secure="true" SSLEnabled="true"    
               clientAuth="false" sslProtocol="TLS"    
               keystoreFile="D:/mycas/tomcat.keystore"      
               keystorePass="890815"/>
```


```
keytool -list -v -keystore  "C:/Program Files/Java/jdk1.8.0_161/jre/lib/security/cacerts"
```
### CAS Client 

CAS Client 部署在客户端， 负责处理 对本地 Web 应用（客户端）受保护资源的访问请求，并且当需要对请求方进行身份认证时，重定向到 CAS Server 进行认证 。
CAS Client 负责部署在客户端（注意，我是指 Web 应用），原则上， CAS Client 的部署意味着，当有对本地 Web 应用的受保护资源的访问请求，并且需要对请求方进行身份认证， Web 应用不再接受任何的用户名密码等类似的 Credentials ，而是重定向到 CAS Server 进行认证。
目前， CAS Client 支持（某些在完善中）非常多的客户端，包括 Java 、 .Net 、 ISAPI 、 Php 、 Perl 、 uPortal 、 Acegi 、 Ruby 、 VBScript 等客户端，几乎可以这样说， CAS 协议能够适合任何语言编写的客户端应用。



### Cas docker 安装


```shell
docker run  --name cas -p 8443:8443 -p 8878:8080  apereo/cas /bin/sh /cas-overlay/bin/run-cas.sh

```
