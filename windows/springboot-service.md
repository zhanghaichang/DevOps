# Spring Boot项目部署为Windows服务

最佳方案：使用winsw，winsw是一个开源项目，程序以及源码可以在Git Hub下载：
[https://github.com/kohsuke/winsw/releases](https://github.com/kohsuke/winsw/releases)

winsw是一个可以将任何应用程序注册成服务的软件，使用方法如下：

1、将Git Hub中下载的WinSW.NET4.exe和sample-minimal.xml文件及springboot项目的jar包放在同一个文件夹中。

2、需要将winsw执行程序跟xml改成同样的名字，推荐使用项目名+Service的命名方式，比如：WinSW.NET4.exe改成myProjectService.exe，sample-minmal.xml改成myProjectService.xml。


3、编辑myProjectService.xml文件，内容如下


```
<configuration>
    <!--安装成Windows服务后的服务名-->
    <id>myProjectServiceID</id>
    <!--显示的服务名称-->
    <name>myProjectServiceName</name>
    <!--对服务的描述-->
    <description>此处可填写该服务的描述</description>
    <!--这里写java的路径，如何配置了环境变量直接写"java"就行-->
    <executable>java</executable>
    <!--Xmx256m 代表堆内存最大值为256MB -jar后面的是项目名-->
    <arguments>-Xmx256m -jar myProject.jar</arguments>
    <!--日志模式-->
    <logmode>rotate</logmode>
</configuration>
```

4、打开系统服务功能：运行——输入cmd，然后进入到myProjectService.exe所在文件夹，然后执行命令安装服务命令：myProjectService.exe install。

5、命令提示符界面输入命令“net start myProjectServiceName”启动服务。


6、打开系统服务功能：运行——输入services.msc，即可看见自己命名的服务myProjectServiceName。

7、测试 ：重启电脑后该服务会自动启动，执行第6步可检查是否成功。

8、删除服务分为两步：1停止服务；2删除服务，都是在命令行界面实现。

> 命令提示符界面输入命令"net stop myProjectServiceName"停止运行服务。

> 命令提示符界面输入命令"myProjectService.exe uninstall"可删除服务

9.上面所有的命令都可以写在批处理文件中，部署的时候就可以实现一键部署了。

```shell
例如myProjectStart.bat内容如下：
myProjectService.exe install
net start myProjectServiceName

例如myProjectStop.bat内容如下：
net stop myProjectServiceName
myProjectService.exe uninstall
```

