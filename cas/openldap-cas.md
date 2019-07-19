# Cas server openldap 配置

可以参考官方文档 https://apereo.github.io/cas/5.3.x/installation/LDAP-Authentication.html#ldap-authentication

进入cas_template文件夹路径，找到pom.xml文件并打开，在其中找到这样一个注释。

```shell
<!--
    ...Additional dependencies may be placed here...
-->
```

进入cas_template文件夹路径，找到pom.xml文件并打开，在其中找到这样一个注释。
```xml
<dependency>
     <groupId>org.apereo.cas</groupId>
     <artifactId>cas-server-support-ldap</artifactId>
     <version>${cas.version}</version>
</dependency>
```
添加依赖并保存后运行打包命令，等待重新生成war包。
```
./build.cmd package
```

将war包上传至服务器，替换旧的war包，并重启tomcat。访问https://[域名]：8443/cas，查看cas是否成功启动。

如果启动失败推荐清空maven仓库，重新下载包，重新生成war包，推荐使用可以翻墙的主机。

接下来配置LDAP的连接属性，进入tomcat的webapp文件夹下，如果上面步骤中打包的war包名字就是cas，那么在进入 webapps/cas/WEB-INF/classes 目录下，修改 application.properties 文件。在文件的最下方就是CAS认证相关的属性，首先注释掉CAS写死的用户名和密码，然后配置LDAP连接属性。
 
 ```shell
 ##
# CAS Authentication Credentials
#
# cas.authn.accept.users=casuser::Mellon

# 认证方式
cas.authn.ldap[0].type=AUTHENTICATED
# LDAP服务地址，如果支持SSL，地址为 ldaps://127.0.0.1:689
cas.authn.ldap[0].ldapUrl=ldap://127.0.0.1:389
# 是否使用SSL
cas.authn.ldap[0].useSsl=false
# LDAP中基础DN
cas.authn.ldap[0].baseDn=dc=example,dc=org
# 用户名匹配规则，简单的可以只写成uid={user}
cas.authn.ldap[0].searchFilter=(|(uid={user})(mail={user})(mobile={user}))
# CAS用于绑定的DN
cas.authn.ldap[0].bindDn=cn=admin,dc=example,dc=org
# CAS用于绑定的DN的密码
cas.authn.ldap[0].bindCredential=admin
# 登入成功后可以查看到的信息，此条可以不写
cas.authn.ldap[0].principalAttributeList=sn,cn:commonName,givenName,eduPersonTargettedId:SOME_IDENTIFIER
 ```
 以上的属性已可以支持LDAP成功对接，完整的属性列表如下，每个属性的具体含义可以查看官网 。

https://apereo.github.io/cas/5.3.x/installation/Configuration-Properties-Common.html#ldap-connection-settings


# Redis对接
