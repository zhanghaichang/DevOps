## 分布式任务调度平台
XXL-JOB是一个轻量级分布式任务调度平台，其核心设计目标是开发迅速、学习简单、轻量级、易扩展。现已开放源代码并接入多家公司线上产品线，开箱即用。

### 环境
* JDK：1.7+
* Servlet/JSP Spec：3.1/2.3
* Tomcat：8.5.x/Jetty9.2.x
* Spring-boot：1.5.x/Spring4.x
* Mysql：5.6+
* Maven：3+


### Docker 镜像方式搭建调度中心：

下载镜像

```shell
// Docker地址：https://hub.docker.com/r/xuxueli/xxl-job-admin/
docker pull xuxueli/xxl-job-admin:2.0.1

```

创建容器并运行

```shell
docker run -p 8080:8080 -v /tmp:/data/applogs --name xxl-job-admin  -d xuxueli/xxl-job-admin

/**
* 如需自定义 mysql 等配置，可通过 "PARAMS" 指定，参数格式 RAMS="--key=value  --key2=value2" ；
* 配置项参考文件：/xxl-job/xxl-job-admin/src/main/resources/application.properties
*/
docker run -e PARAMS="--spring.datasource.url=jdbc:mysql://127.0.0.1:3306/xxl-job?Unicode=true&characterEncoding=UTF-8" -p 8080:8080 -v /tmp:/data/applogs --name xxl-job-admin  -d xuxueli/xxl-job-admin:2.0.1
```
### 执行器
