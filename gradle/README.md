# gradle

>Gradle是源于Apache Ant和Apache Maven概念的项目自动化构建开源工具，它使用一种基于Groovy的特定领域语言(DSL)来声明项目设置，抛弃了基于XML的各种繁琐配置面向Java应用为主。当前其支持的语言暂时有Java、Groovy、Kotlin和Scala。

Gradle是一个基于JVM的构建工具，是一款通用灵活的构建工具，支持maven， Ivy仓库，支持传递性依赖管理，而不需要远程仓库或者是pom.xml和ivy.xml配置文件，基于Groovy，build脚本使用Groovy编写。


## 下载
官方网站：https://gradle.org/install/#manually

提供了两种下载方式，Binary-only是只下载二进制源码，Complete, with docs and sources是下载源码和文档。如果有阅读文档的需求可以下载第二个，没有需要的下载Binary-only即可。


理解了gradle wrapper的概念，下面一些常用命令也就容易理解了。
```
./gradlew -v 版本号

./gradlew clean 清除9GAG/app目录下的build文件夹

./gradlew build 检查依赖并编译打包
```
这里注意的是 ./gradlew build 命令把debug、release环境的包都打出来，如果正式发布只需要打Release的包，该怎么办呢，下面介绍一个很有用的命令 assemble, 如
```
./gradlew assembleDebug 编译并打Debug包

./gradlew assembleRelease 编译并打Release的包
```

## 常用命令

```gradle
#查看所有可用的task
gradle task

#编译（编译过程中会进行单元测试）
gradle build

#单元测试
gradle test

#编译时跳过单元测试
gradle build -x test

#直接运行项目 
gradle run

#清空所有编译、打包生成的文件(即：清空build目录)
gradle clean

#生成mybatis的model、mapper、xml映射文件，注： 生成前，先修改src/main/resources/generatorConfig.xml 文件中的相关参数 ， 比如：mysql连接串，目标文件的生成路径等等
gradle mybatisGenerate

#生成可运行的jar包，生成的文件在build/install/hello-gradle下，其中子目录bin下为启动脚本， 子目录lib为生成的jar包
gradle installApp

#打包源代码，打包后的源代码，在build/libs目录下
gradle sourcesJar

#安装到本机maven仓库，此命令跟maven install的效果一样
gradle install

#生成pom.xml文件，将会在build根目录下生成pom.xml文件，把它复制项目根目录下，即可将gradle方便转成maven项目
gradle createPom
```

## Gradle配置本地仓库

一、配置远程阿里云仓库

在gradle目录下的init.d目录中创建名为init.gradle文件，内容如下：

```
allprojects{
    repositories {
        def REPOSITORY_URL = 'http://maven.aliyun.com/nexus/content/groups/public/'
        all { ArtifactRepository repo ->
            if(repo instanceof MavenArtifactRepository){
                def url = repo.url.toString()
                if (url.startsWith('https://repo1.maven.org/maven2') || url.startsWith('https://jcenter.bintray.com/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $REPOSITORY_URL."
                    remove repo
                }
            }
        }
        maven {
            url REPOSITORY_URL
        }
    }
}
```

二、配置本地仓库位置

在环境变量中添加所希望的本地仓库

> GRADLE_USER_HOME=D:\gradle-6.0.1\repos

三、提高编译速度

在gradle仓库.gradle目录下创建一个gradle.properties 文件，在其中添加如下语句:

> org.gradle.daemon=true


