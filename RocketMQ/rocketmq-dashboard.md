# Rocketmq dashboard

下载源码
```
git clone https://github.com/apache/rocketmq-dashboard.git
```

在resource/application.properties中更改rocketmq.config.namesrvAddr。（也可以在ops页中更改）

编译构建
```
mvn clean package -Dmaven.test.skip=true
java -jar target/rocketmq-console-ng-1.0.1.jar
```
