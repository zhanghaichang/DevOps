# IIS8.0调优


### 1.修改IIS的 appConcurrentRequestLimit 设置

默认值是5000，修改为100000（或者更大的值）

>c:/windows/system32/inetsrv/appcmd.exe set config /section:serverRuntime /appConcurrentRequestLimit:100000

在%systemroot%\System32\inetsrv\config\applicationHost.config中可以查看到该设置：

><serverRuntime appConcurrentRequestLimit="50000" />

### 2.修改machine.config中的processModel>requestQueueLimit的设置

由原来的默认5000改为50000

* [1] 单击“开始”，然后单击“运行”，或者 windows + R。

* [2] 在“运行”对话框中，键入 notepad %systemroot%/Microsoft.Net/Framework64/v4.0.30319/CONFIG/machine.config，然后单击“确定”。(不同的.NET版本路径不一样，可以选择你自己当前想设置的.NET版本的config)

* [3] 找到如下所示的 processModel 元素：`<processModel autoConfig="true" />`

* [4] 将 processModel 元素替换为以下值：`<processModel enable="true" requestQueueLimit="15000" />`

* [5] 保存并关闭 Machine.config 文件。

>`<processModel enable="true" requestQueueLimit="15000" maxWorkerThreads="100" maxIoThreads="100" minWorkerThreads="50" minIoThreads="50" />`

有4个相关设置：maxWorkerThreads（默认值是20）, maxIoThreads（默认值是20）, minWorkerThreads（默认值是1）, minIoThreads（默认值是1）。（这些设置是针对每个CPU核）

我们用的就是默认设置，由于我们的Web服务器是8核的，于是实际的maxWorkerThreads是160，实际的maxIoThreads是160，实际的minWorkerThreads是8，实际的minIoThreads是8。

基于这样的设置，是不是如果瞬间并发请求是169，就会出现排队？不是的，ASP.NET没这么傻！因为CLR 1秒只能创建2个线程（"The CLR ThreadPool injects new threads at a rate of about 2 per second. "），等线程用完时才创建，黄花菜都凉了。我们猜测ASP.NET只是根据这个设置去预测线程池中的可用线程是不是紧张，是不是需要创建新的线程，以及创建多少线程。

那什么情况下会出现“黑色30秒”期间那样的大量请求排队？假如并发请求数平时是300，突然某个瞬间并发请求数是600，超出了ASP.NET预估的所需的可用线程数，于是那些拿不到线程的请求只能排队等待正在执行的请求释放线程以及CLR创建新的线程。随着时间的推移，释放出来的线程+新创建的线程足以处理这些排队的请求，就恢复了正常。


### 3.修改注册表，调整IIS支持的同时TCPIP连接数

>reg add HKLM\System\CurrentControlSet\Services\HTTP\Parameters /v MaxConnections /t REG_DWORD /d 100000

注册表设置命令2（解决Bad Request - Request Too Long问题）：

>reg add HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/services/HTTP/Parameters /v MaxFieldLength /t REG_DWORD /d 32768
>reg add HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/services/HTTP/Parameters /v MaxRequestBytes /t REG_DWORD /d 32768



### 4.要提高IIS并发处理能力，首先要调整IIS队列大小

把队列长度调整到65535，禁止重叠回收，最大故障数改成65530，这三点必须要改，不然实现不了10万并发效果.
这里建议队列长度大小为：65535(默认：1000)。这个值怎么计算，有种说法是，队列长度= 访问用户*1.5。


