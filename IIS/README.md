# IIS8.0调优


### 1.修改IIS的 appConcurrentRequestLimit 设置

默认值是5000，修改为50000（或者更大的值）

>c:\windows\system32\inetsrv\appcmd.exe set config /section:serverRuntime /appConcurrentRequestLimit:50000

在%systemroot%\System32\inetsrv\config\applicationHost.config中可以查看到该设置：

><serverRuntime appConcurrentRequestLimit="50000" />

### 2.修改machine.config中的processModel>requestQueueLimit的设置

由原来的默认5000改为50000

* [1] 单击“开始”，然后单击“运行”，或者 windows + R。

* [2] 在“运行”对话框中，键入 notepad %systemroot%/Microsoft.Net/Framework64/v4.0.30319/CONFIG/machine.config，然后单击“确定”。(不同的.NET版本路径不一样，可以选择你自己当前想设置的.NET版本的config)

* [3] 找到如下所示的 processModel 元素：<processModel autoConfig="true" />

* [4] 将 processModel 元素替换为以下值：<processModel enable="true" requestQueueLimit="15000" />

* [5] 保存并关闭 Machine.config 文件。

><processModel enable="true" requestQueueLimit="50000"/>


### 3.修改注册表，调整IIS支持的同时TCPIP连接数

>reg add HKLM\System\CurrentControlSet\Services\HTTP\Parameters /v MaxConnections /t REG_DWORD /d 100000

注册表设置命令2（解决Bad Request - Request Too Long问题）：

>reg add HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/services/HTTP/Parameters /v MaxFieldLength /t REG_DWORD /d 32768
>reg add HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/services/HTTP/Parameters /v MaxRequestBytes /t REG_DWORD /d 32768



### 4.要提高IIS并发处理能力，首先要调整IIS队列大小

这里建议队列长度大小为：65535(默认：1000)。这个值怎么计算，有种说法是，队列长度= 访问用户*1.5。


