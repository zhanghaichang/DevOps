# Weblogic

> WebLogic 脚本工具 (WLST) 是一个命令行脚本界面，系统管理员和操作员可以使用它来监视和管理 WebLogic Server 实例和域。WLST 脚本环境基于 Java 脚本解释器 Jython。除 WebLogic 脚本功能外，还可以使用解释语言（包括本地变量、条件变量以及流控制语句）的常用功能。WebLogic Server 开发人员和管理员可以按照 Jython 语言语法扩展 WebLogic 脚本语言，以满足其环境需要。


## docker 安装

```
docker pull ismaleiva90/weblogic12
```

## 运行

```
docker run -d -p 49163:7001 -p 49164:7002 -v <host directory>:/u01/oracle/user_projects -p 49165:5556 ismaleiva90/weblogic12:latest
```

访问地址

```
http://localhost:49163/console
User: weblogic
Pass: welcome1
```

```
/u01/oracle/weblogic/user_projects/
```
