# mysqladmin


mysqladmin 工具的使用格式：
``
mysqladmin [option] command [command option] command ......
参数选项：
-c number 自动运行次数统计，必须和 -i 一起使用
-i number 间隔多长时间重复执行
```
### 0）每个两秒查看一次服务器的状态，总共重复5次。
```
[root@test-huanqiu ~]# mysqladmin -uroot -p -i 2 -c 5 status
```

1）查看服务器的状况：status
[root@test-huanqiu ~]# mysqladmin -uroot -p status

2）修改root 密码：
[root@test-huanqiu ~]# mysqladmin -u root -p原密码 password 'newpassword'

3）检查mysqlserver是否可用：
[root@test-huanqiu ~]# mysqladmin -uroot -p ping

4）查询服务器的版本
[root@test-huanqiu ~]# mysqladmin -uroot -p version

5）查看服务器状态的当前值：
[root@test-huanqiu ~]# mysqladmin -uroot -p extended-status

6）查询服务器系统变量值：
[root@test-huanqiu ~]# mysqladmin -uroot -p variables

7）显示服务器所有运行的进程：
[root@test-huanqiu ~]# mysqladmin -uroot -p processlist
[root@test-huanqiu ~]# mysqladmin -uroot -p-i 1 processlist        //每秒刷新一次

8）创建数据库
[root@test-huanqiu ~]# mysqladmin -uroot -p create daba-test

9）显示服务器上的所有数据库
[root@test-huanqiu ~]# mysqlshow -uroot -p

10）显示数据库daba-test下有些什么表：
[root@test-huanqiu ~]# mysqlshow -uroot -p daba-test

11）统计daba-test 下数据库表列的汇总
[root@test-huanqiu ~]# mysqlshow -uroot -p daba-test -v

12）统计daba-test 下数据库表的列数和行数
[root@test-huanqiu ~]# mysqlshow -uroot -p daba-test -v -v

13）删除数据库 daba-test
[root@test-huanqiu ~]# mysqladmin -uroot -p drop daba-test

14）重载权限信息
[root@test-huanqiu ~]# mysqladmin -uroot -p reload

15）刷新所有表缓存，并关闭和打开log
[root@test-huanqiu ~]# mysqladmin -uroot -p refresh

16）使用安全模式关闭数据库
[root@test-huanqiu ~]# mysqladmin -uroot -p shutdown

17）刷新命令mysqladmin flush commands
[root@test-huanqiu ~]# mysqladmin -u root -ptmppassword flush-hosts
[root@test-huanqiu ~]# mysqladmin -u root -ptmppassword flush-logs
[root@test-huanqiu ~]# mysqladmin -u root -ptmppassword flush-privileges
[root@test-huanqiu ~]# mysqladmin -u root -ptmppassword flush-status
[root@test-huanqiu ~]# mysqladmin -u root -ptmppassword flush-tables
[root@test-huanqiu ~]# mysqladmin -u root -ptmppassword flush-threads

18）mysqladmin 执行kill 进程：
[root@test-huanqiu ~]# mysqladmin -uroot -p processlist
[root@test-huanqiu ~]# mysqladmin -uroot -p kill idnum

19）停止和启动MySQL replication on a slave server
[root@test-huanqiu ~]# mysqladmin -u root -p stop-slave
[root@test-huanqiu ~]# mysqladmin -u root -p start-slave

20）同时执行多个命令
[root@test-huanqiu ~]# mysqladmin -u root -p process status version
