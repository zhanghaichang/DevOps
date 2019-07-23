# archetype



编辑原型项目的pom文件,添加编码格式和发布的nexus地址

```
<properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>  
    </properties>
   <distributionManagement>
        <snapshotRepository>
            <id>snapshots</id>
            <name>Snapshots</name>
            <url>http://localhost:8081/nexus/content/repositories/snapshots/</url>
        </snapshotRepository>
        <repository>
            <id>releases</id>
            <name>Releases</name>
            <url>http://localhost:8081/nexus/content/repositories/releases/</url>
        </repository>
    </distributionManagement>
```
