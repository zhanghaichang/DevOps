# 本地Windows环境安装RabbitMQ Server


* 一：安装RabbitMQ需要先安装Erlang语言开发包，百度网盘地址：http://pan.baidu.com/s/1jH8S2u6。直接下载地址：http://erlang.org/download/otp_win64_18.3.exe。

安装完成后需要配置环境变量：

新建系统变量：变量名 ERLANG_HOME 变量值 D:\softInstall\erl8.3（Erlang安装目录）

添加到PATH：%ERLANG_HOME%\bin;

*  二：安装RabbitMQ Server，百度网盘地址：http://pan.baidu.com/s/1eRLlSrg。直接下载地址：http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.9/rabbitmq-server-3.6.9.exe。

安装完成后需要配置环境变量：

新建系统变量：变量名 RABBITMQ_SERVER 变量值 D:\softInstall\rabbitMQ\rabbitmq_server-3.6.9（RabbitMQ Server安装目录）

添加到PATH：%RABBITMQ_SERVER%\sbin;

* 三：以管理员身份运行cmd.exe，进入目录D:\softInstall\rabbitMQ\rabbitmq_server-3.6.9\sbin（RabbitMQ Server安装目录），运行cmd命令：rabbitmq-plugins.bat enable rabbitmq_management

* 四：以管理员身份运行cmd.exe，运行命令：net stop RabbitMQ && net start RabbitMQ。启动RabbitMQ Server，在浏览器输入地址：
[http://localhost:15672](http://localhost:15672)，输入默认账号：guest  密码：guest，就能进入RabbitMQ界面了。

至此，RabbitMQ Server安装完成。
