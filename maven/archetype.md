# archetype

1 .进入模版项目的根目录，执行命令：mvn archetype:create-from-project

生成以该项目为模版的项目原型(archetype)，具体的项目结构在target/generated-sources目录下；

注意：生成的archetype包含模板项目中所有的文档，避免冗余，可将多余文件删除，并对其项目结构做一些整理！！！

a、修改archetype目录下pom.xml，将archetype的名称修改成你喜欢的；

b、可将文件夹改成_rootArtifactId_，这样生成项目结构时，这个目录名称就会变成新的项目名称了；

这些都整理好了之后，可以将其发布到nexus仓库供其它同事使用了，发布的方法如下：

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


执行mvn deploy部署archetype到私服或者中央仓库，注意pom.xml需要设置私服的地址和archetype的坐标信息（下一步测试需要）。
