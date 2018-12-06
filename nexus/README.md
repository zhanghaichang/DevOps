# nexus maven 安装

### Docker 安装

```
sudo docker run -d -p 8081:8081 --restart=always --name nexus -v /data/nexus:/nexus-data sonatype/nexus3:3.14.0
```
### 配置Settings.xml文件

```xml
  <!--配置私服-->
     <server>
      <id>nexus-snapshots</id>
      <username>admin</username>
      <password>admin123</password>
    </server>
    <server>
      <id>nexus-releases</id>
      <username>admin</username>
      <password>admin123</password>
    </server>


 <!--配置私服-->
    <mirror>
      <id>nexus</id>
      <name>central</name>
      <url>http://123.207.66.156:8081/repository/maven-public/</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
```
