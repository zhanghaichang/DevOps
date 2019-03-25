# CAS

Central Authentication Service (CAS)，通常称为CAS。 CAS是一种针对Web的企业多语言单点登录解决方案，并尝试成为您的身份验证和授权需求的综合平台。


### CAS Server

CAS Server 需要独立部署，主要负责对用户的认证工作， 它会处理用户名 / 密码等凭证 (Credentials) ；
CAS Server 负责完成对用户的认证工作， CAS Server 需要独立部署，有不止一种 CAS Server 的实现， Yale CAS Server 和 ESUP CAS Server 都是很不错的选择。
CAS Server 会处理用户名 / 密码等凭证 (Credentials) ，它可能会到数据库检索一条用户帐号信息，也可能在 XML 文件中检索用户密码，对这种方式， CAS 均提供一种灵活但同一的接口 / 实现分离的方式， CAS 究竟是用何种认证方式，跟 CAS 协议是分离的，也就是，这个认证的实现细节可以自己定制和扩展。




### CAS Client 

CAS Client 部署在客户端， 负责处理 对本地 Web 应用（客户端）受保护资源的访问请求，并且当需要对请求方进行身份认证时，重定向到 CAS Server 进行认证 。
CAS Client 负责部署在客户端（注意，我是指 Web 应用），原则上， CAS Client 的部署意味着，当有对本地 Web 应用的受保护资源的访问请求，并且需要对请求方进行身份认证， Web 应用不再接受任何的用户名密码等类似的 Credentials ，而是重定向到 CAS Server 进行认证。
目前， CAS Client 支持（某些在完善中）非常多的客户端，包括 Java 、 .Net 、 ISAPI 、 Php 、 Perl 、 uPortal 、 Acegi 、 Ruby 、 VBScript 等客户端，几乎可以这样说， CAS 协议能够适合任何语言编写的客户端应用。



### Cas docker 安装


```shell
docker run  --name cas -p 8443:8443 -p 8878:8080  apereo/cas /bin/sh /cas-overlay/bin/run-cas.sh

```
