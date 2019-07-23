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

5.执行maven命令deploy将原型项目发布到nexus仓库.

6.eclipse中点选Window---Preferences---maven---Archetypes,点选Add Remote Catalog,输入nexus中的地址并取一个描述名字.nexus的地址形如:

http://localhost:8081/nexus/content/groups/public/archetype-catalog.xml  ,为archetype-catalog.xml文件的地址.
