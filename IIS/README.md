# IIS8.0调优


### 1.修改IIS的 appConcurrentRequestLimit 设置

默认值是5000，修改为50000（或者更大的值）

>c:\windows\system32\inetsrv\appcmd.exe set config /section:serverRuntime /appConcurrentRequestLimit:50000
