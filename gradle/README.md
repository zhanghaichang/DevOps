# gradle


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
