# Openldap 客户端常用管理命令

## 1、ldapadd

* -x: 简答认证方式
* -W: 不需要在命令上写密码 ldapapp -x -D "cn=Manager,dc=suixingpay,dc=com" -W
* -w: password 需要命令上指定密码 ldapapp -x -D "cn=Manager,dc=suixingpay,dc=com" -w 123456
* -H: 通过ldapapi
* -h: hostname/ipaddress
* -D: "cn=Manager,dc=suixingpay,dc=com"
* -p: 端口 明文389 密文636
* -v: 显示详细
* -f: filename.ldif文件
* -a: 新增条目

```shell
cat << EOF| ldapadd -x -D "cn=Manager,dc=suixingpay,dc=com" -w 123456
dn: uid=jaxzhai,ou=运维部,ou=研发中心,dc=suixingpay,dc=com
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
homeDirectory: /home/zhan_zf
userPassword: {SSHA}l9gQmGTK9TsC7SUQpVOpm/aimoYYdPd3
loginShell: /bin/bash
cn: jaxzhai
uidNumber: 1001
gidNumber: 1010
sn: System Administrator
mail: @suixingpay.com
postalAddress: beijing
mobile: 18111111111
EOF


通过文件
ldapadd -x -D "cn=Manager,dc=suixingpay,dc=com" -w 123456 -f filename.ldi
```

## 2、ldapdelete

参数和ldapadd类似

```
ldapdelete -x -D "cn=Manager,dc=suixingpay,dc=com" -w 123456 -h172.16.138.87 "uid=zhan_z,ou=运维部,ou=研发中心,dc=suixingpay,dc=com"
```

## 3、ldapmodify

指定库文件和类型

可以使用 changetype: modify 关键字在现有条目中添加、替换或删除属性及属性值。指定 changetype: modify 时，还必须提供一个或多个更改操作，表明将如何修改条目。

```
cat << EOF| ldapmodify -x -D "cn=Manager,dc=suixingpay,dc=com" -w123456
dn: uid=zhan_z,ou=运维部,ou=研发中心,dc=suixingpay,dc=com
changetype: modify
replace: loginShell
loginShell: /sbin/nologin
EOF
```

## 4、ldapmodrdn(就是修改dn的)

```
cat << EOF| ldapmodrdn -x -D "cn=Manager,dc=suixingpay,dc=com" -w123456
dn: uid=jaxzhai,ou=运维部,ou=研发中心,dc=suixingpay,dc=com
changetype: modrdn
newrdn: uid=jax
deleteoldrnd: 1
EOF

#等同上面（但是没有删除旧的uid,加-r删除）
ldapmodrdn -x -D "cn=Manager,dc=suixingpay,dc=com" -w123456 "uid=jaxzhai,ou=运维部,ou=研发中心,dc=suixingpay,dc=com" "uid=zhan"
```

## 5、ldappasswd

```
#-s 指定密码
ldappasswd -x -D "cn=Manager,dc=suixingpay,dc=com" -w123456 -h172.16.138.87 "uid=zhan_z,ou=运维部,ou=研发中心,dc=suixingpay,dc=com"  -s123456
#-S 交互式
ldappasswd -x -D "cn=Manager,dc=suixingpay,dc=com" -w123456 -h172.16.138.87 "cn=guolitao,ou=mysql,ou=研发中心,dc=suixingpay,dc=com"  -S
#-a 根据旧密码产生随机密码
ldappasswd -x -D "cn=Manager,dc=suixingpay,dc=com" -w123456 -h172.16.138.87 "uid=zhan_z,ou=运维部,ou=研发中心,dc=suixingpay,dc=com"  -a123456
#不指定 产生随机密码
ldappasswd -x -D "cn=Manager,dc=suixingpay,dc=com" -w123456 -h172.16.138.87 "uid=zhan_z,ou=运维部,ou=研发中心,dc=suixingpay,dc=com"
```

## 6、ldapsearch

```
#显示所有uid的条目
ldapsearch -x -LLL uid
#指定uid显示
ldapsearch -x -LLL uid=zhaikun
# "+"显示隐藏属性
ldapsearch -x -LLL uid=zhaikun +
```
## 7、ldapwhoami 验证用户有没有修改密码

```
ldapwhoami -x -D "uid=jaxzhai,ou=运维部,ou=研发中心,dc=suixingpay,dc=com" -w123456 
```
