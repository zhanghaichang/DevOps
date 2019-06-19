# rsync同步工具

**rsync命令**是一个远程数据同步工具，可通过LAN/WAN快速同步多台主机间的文件。rsync使用所谓的“rsync算法”来使本地和远程两个主机之间的文件达到同步，这个算法只传送两个文件的不同部分，而不是每次都整份传送，因此速度相当快。

*   rsync功能 
    *   作为命令，实现本地-远程文件同步
    *   作为服务，实现本地-远程文件同步
*   rsync特点 
    *   可以镜像保存整个目录树和文件系统
    *   可以保留原有的权限(permission,mode)，owner,group,时间(修改时间,modify time)，软硬链接，文件acl,文件属性(attributes)信息等
    *   传输效率高，使用同步算法，只比较变化的
    *   支持匿名传输，方便网站镜像；也可以做验证，加强安全
*   rsync同类服务 
    *   sync 同步：刷新文件系统缓存，强制将修改过的数据块写入磁盘，并且更新超级块。
    *   async 异步：将数据先放到缓冲区，再周期性（一般是30s）的去同步到磁盘。
    *   rsync 远程同步：remote synchronous

**rsync -av /etc/passwd /tmp/1.txt**

![](https://oscimg.oschina.net/oscnet/0f69c962023bcdd957de1c382ef4afbe40b.jpg)

**rsync -av /tmp/1.txt 192.168.36.131:/tmp/2.txt **

![](https://oscimg.oschina.net/oscnet/a4e5ef3cd029685c41dd1b60edfe4a08814.jpg)  
rsync -av /tmp/1.txt 192.168.188.128:/tmp/2.txt

![](https://oscimg.oschina.net/oscnet/69975487a59064af3451f2e0165e1f10965.jpg)

** rsync格式**
------------

    rsync [OPTION] … SRC   DEST
    rsync [OPTION] … SRC   [user@]host:DEST
    rsync [OPTION] … [user@]host:SRC   DEST
    rsync [OPTION] … SRC   [user@]host::DEST
    rsync [OPTION] … [user@]host::SRC   DEST
    

**rsync常用选项**
-------------

    -a 包含-rtplgoD
    -r 同步目录时要加上，类似cp时的-r选项
    -v 同步时显示一些信息，让我们知道同步的过程
    -l 保留软连接
    -L 加上该选项后，同步软链接时会把源文件给同步
    -p 保持文件的权限属性
    -o 保持文件的属主
    -g 保持文件的属组
    -D 保持设备文件信息
    -t 保持文件的时间属性
    --delete 删除DEST中SRC没有的文件
    --exclude 过滤指定文件，如--exclude “logs”会把文件名包含logs的文件或者目录过滤掉，不同步
    -P 显示同步过程，比如速率，比-v更加详细
    -u 加上该选项后，如果DEST中的文件比SRC新，则不同步
    -z 传输时压缩
    

**rsync通过ssh方式同步**
------------------

推文件：

![](https://oscimg.oschina.net/oscnet/ecd0181f48484d36fe59a7458cb62996f65.jpg)

拉文件：

![](https://oscimg.oschina.net/oscnet/4b7a5589384db4e3f4515ad368c3519a3f2.jpg)

-e "ssh -p 22" 指定端口：  
![](https://oscimg.oschina.net/oscnet/c6735c93ee531cefbc053ddfd02d3884497.jpg)

** rsync 通过服务的方式同步**
--------------------

     1.编辑配置文件/etc/rsyncd.conf
     2.启动服务rsync --daemon
     3.格式：rsync -av test1/ test@192.168.36.130::test/
    

rsyncd.conf样例：

    port=873
    log file=/var/log/rsync.log
    pid file=/var/run/rsyncd.pid
    address=192.168.36.130
    [test]
    path=/tmp/rsync
    use chroot=true
    max connections=4
    read only=no
    list=true
    uid=root
    gid=root
    auth users=test
    secrets file=/etc/rsyncd.passwd
    hosts allow=192.168.36.131 （多个ip以空格隔开，也可以写ip段：192.168.36.0/24）
    

 rsyncd.conf配置文件详解  

     port：指定在哪个端口启动rsyncd服务，默认是873端口。
     log file：指定日志文件。
     pid file：指定pid文件，这个文件的作用涉及服务的启动、停止等进程管理操作。
     address：指定启动rsyncd服务的IP。假如你的机器有多个IP，就可以指定由其中一个启动rsyncd服务，如果不指定该参数，默认是在全部IP上启动。
     []：指定模块名，里面内容自定义。
     path：指定数据存放的路径。
     use chroot true|false：表示在传输文件前首先chroot到path参数所指定的目录下。这样做的原因是实现额外的安全防护，但缺点是需要以roots权限，并且不能备份指向外部的符号连接所指向的目录文件。默认情况下chroot值为true，如果你的数据当中有软连接文件，阿铭建议你设置成false。
     max connections：指定最大的连接数，默认是0，即没有限制。
     read only ture|false：如果为true，则不能上传到该模块指定的路径下。
     list：表示当用户查询该服务器上的可用模块时，该模块是否被列出，设定为true则列出，false则隐藏。
     uid/gid：指定传输文件时以哪个用户/组的身份传输。
     auth users：指定传输时要使用的用户名。
     secrets file：指定密码文件，该参数连同上面的参数如果不指定，则不使用密码验证。注意该密码文件的权限一定要是600。格式：用户名:密码
     hosts allow：表示被允许连接该模块的主机，可以是IP或者网段，如果是多个，中间用空格隔开。 
     当设置了auth users和secrets file后，客户端连服务端也需要用用户名密码了，若想在命令行中带上密码，可以设定一个密码文件
     rsync -avL test@192.168.36.130::test/test1/  /tmp/test8/ --password-file=/etc/pass 
     其中/etc/pass内容就是一个密码，权限要改为600
    

把端口改了之后需要使用--port 指定端口

![](https://oscimg.oschina.net/oscnet/f6af7c61eff2357831dc41cda21419b26cc.jpg)

![](https://oscimg.oschina.net/oscnet/7bab11b8bd63689474843be730e45bb0794.jpg)
------------------------------------------------------------------------------

客服端配置密码文件可不用输入密码：

这里密码文件格式只有密码

![](https://oscimg.oschina.net/oscnet/75d103c4c90facaccb3cef2e9ebb9a6b1c3.jpg)

(adsbygoogle = window.adsbygoogle || \[\]).push({});

© 著作权归作者所有

公司内的帐号系统一般使用openldap，openldap相对于把帐号存入mysql等关系数据库中开发和维护成本都比较低，所以openldap成了公司内帐号体系最合适的选择

可以通过下面的内容快速上手这个openldap帐号系统

名词概念
----

这个ldap里面使用了很多的别名，下面列出了常用的别名

dn: 区别名，类比mysql的主键id

cn: 常用名，类比用户的呢称（全名）

sn: 用户的姓氏

giveName: 用户名字(不包含姓)

dc: 所属域名，类比命名空间，一个用户可以存在在多个dc中

uid: 登录使用的名称

c: 所属国家，比如CN表示中国

ou: 所属组织

LDIF: openldap的数据描述格式，类比linux的/etc/passwd文件格式，使用固定的格式来描述包含的数据

    dn:uid=1,ou=firstunit,o=myorganization,dc=example,dc=org
    objectclass:top
    objectclass:person
    objectclass:uidObject
    objectclass:simpleSecurityObject
    userPassword:123456
    cn:第一个用户
    sn:su
    uid:1
    telephoneNumber：13288888888
    复制代码

注意：很多objectClass都会提供额外的字段，比如上面的telephoneNumber字段就是person这个objectClass提供的

objectClass列表参考：[www.zytrax.com/books/ldap/…](https://link.juejin.im?target=http%3A%2F%2Fwww.zytrax.com%2Fbooks%2Fldap%2Fape%2F%23objectclasses) 可以通过定义schema创建新的objectClass: [www.openldap.org/doc/admin24…](https://link.juejin.im?target=http%3A%2F%2Fwww.openldap.org%2Fdoc%2Fadmin24%2Fschema.html)

搭建openldap服务器
-------------

可以使用这个docker一键启动openldap服务器，参考：[github.com/osixia/dock…](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fosixia%2Fdocker-openldap) 编写docker-compose.yml如下

    version: '3'
    
    services:
        ldap:
          image: osixia/openldap:1.2.4
          environment:
            - TZ=PRC
          ports:
            - 389:389
            - 636:636
        admin:
          image: osixia/phpldapadmin:0.8.0
          volumes:
            - ./data/admin/config:/container/service/phpldapadmin/assets/config
          ports:
            - 6443:443
          links:
            - ldap
    复制代码

然后启动

    docker-compose up -d
    复制代码

使用命令`docker-compose ps`可以查看启动效果

![](https://user-gold-cdn.xitu.io/2019/6/9/16b3c20ce14199f3?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

可以看到这个ldap服务器已经在389端口监听了

这个docker创建的管理员帐号是：cn=admin,dc=example,dc=org 密码：admin 默认的域名是：dc=example,dc=org

组织架构
----

用户体系一般体现了公司的组织架构，常用的组织架构有下面两种

1.  互联网命名的组织架构：根节点为国家，国家下为域名，域名下为组织/组织单元，再往下为用户
2.  企业命名的组织架构：根节点为域名，域名下面为部门，部门下面为用户

下面就用企业命名的组件架构举例

命令行操作
-----

### 创建数据

构建ldif文件，比如myo.ldif

    dn:o=myorganization,dc=example,dc=org
    objectclass:top
    objectclass:organization
    o:myorganization
    description:我的组织
    
    dn:ou=firstunit,o=myorganization,dc=example,dc=org
    objectclass:top
    objectclass:organizationalUnit
    description:组织里的第一个单位
    
    dn:uid=1,ou=firstunit,o=myorganization,dc=example,dc=org
    objectclass:top
    objectclass:person
    objectclass:uidObject
    objectclass:simpleSecurityObject
    userPassword:123456
    cn:第一个用户
    sn:su
    uid:1
    复制代码

然后导入到ldap服务器里面

    docker-compose exec ldap bash
    ldapadd  -x  -D "cn=admin,dc=example,dc=org"  -W  -f myo.ldif
    复制代码

操作效果如下

![](https://user-gold-cdn.xitu.io/2019/6/9/16b3c20c9e302ba1?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

可以看到数据已经成功导入了

### 搜索数据

可以使用ldapsearch命令查找数据，比如查找这个域名: dc=example,dc=org 下的所有数据

    ldapsearch -x -H ldap://localhost -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w admin
    复制代码

操作效果如下

![](https://user-gold-cdn.xitu.io/2019/6/9/16b3c20c8ab4a1fe?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

可以看到查询成功执行了

### 备份数据

使用`slapcat -v -l mybackup.ldif`进行备份 操作效果如下

![](https://user-gold-cdn.xitu.io/2019/6/9/16b3c20c88891c55?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

### 清空数据

可以使用`ldapdelete -x -D "cn=admin,dc=example,dc=org" -w admin -r "dc=example,dc=org"`命令清空example,dc=org下的所有oepnldap的数据

操作效果如下：

![](https://user-gold-cdn.xitu.io/2019/6/9/16b3c20c840483a2?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

注意并没有删除dc=example,dc=org这条记录

### 恢复数据

注意：恢复前需要把备份文件中的这些字段先删掉

1.  creatorsName
2.  modifiersName
3.  modifyTimestamp
4.  createTimestamp
5.  entryUUID
6.  entryCSN
7.  structuralObjectClass 然后删掉这条记录dn: dc=example,dc=org

使用命令`ldapadd -x -D"cn=admin,dc=example,dc=org" -w admin -f mybackup.ldif`进行导入

操作效果如下

![](https://user-gold-cdn.xitu.io/2019/6/9/16b3c20ca74ac72c?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

使用ldapsearch命令进行验证

![](https://user-gold-cdn.xitu.io/2019/6/9/16b3c20d6d840fc1?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

可以看到数据已经成功导入了

客户端
---

ldap目前有三个客户端可以选择

1.  jxplorer: [jxplorer.org/](https://link.juejin.im?target=http%3A%2F%2Fjxplorer.org%2F)
2.  Apache Directory Studio
3.  phpLDAPadmin

jxplorer有中文界面，并且简单容易上手，Apache Directory Studio功能强大，建议先使用jxplorer上手，然后再使用Apache Directory Studio进行操作，phpLDAPadmin可以自行了解

程序客户端
-----

*   java参考：[docs.spring.io/spring-ldap…](https://link.juejin.im?target=https%3A%2F%2Fdocs.spring.io%2Fspring-ldap%2Fdocs%2Fcurrent%2Freference%2F)
*   php参考：[github.com/Adldap2/Adl…](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2FAdldap2%2FAdldap2)
*   go参考：[github.com/go-ldap/lda…](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fgo-ldap%2Fldap)

一些注意的点
------

定义有密码用户使用simpleSecurityObject这个objectClass，比如

    dn: cn=suxiaolin,dc=example,dc=org
    objectClass: organizationalRole
    objectclass: simpleSecurityObject
    cn: suxiaolin
    userPassword:123456
    复制代码

这个userPassword字段的值就是用户密码

参考资料
----

1.  [explainshell.com/explain/1/l…](https://link.juejin.im?target=https%3A%2F%2Fexplainshell.com%2Fexplain%3Fcmd%3Dldapsearch%2B-x%2B-H%2Bldap%253A%252F%252Flocalhost%2B-b%2Bdc%253Dexample%252Cdc%253Dorg%2B-D%2B%2522cn%253Dadmin%252Cdc%253Dexample%252Cdc%253Dorg%2522%2B-w%2Badmin)
2.  [github.com/osixia/dock…](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fosixia%2Fdocker-openldap)
3.  [github.com/osixia/dock…](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fosixia%2Fdocker-phpLDAPadmin)
