## Docker Compose

### Linux系统上安装Compose

在Linux上，您可以从GitHub上的Compose存储库发行页面下载Docker Compose二进制文件。按照链接中的说明进行操作，该链接涉及curl在终端中运行命令以下载二进制文件。这些分步说明也包括在下面。

#### 1.运行此命令以下载最新版本的Docker Compose：

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
#### 2. 对二进制文件应用可执行权限：

```
sudo chmod +x /usr/local/bin/docker-compose
```

#### 3.（可选）为 和shell 安装命令完成。
```
bashzsh
```

#### 4.测试安装

```
$ docker-compose --version
docker-compose version 1.22.0, build 1719ceb
```

### 升级

如果从Compose 1.2或更早版本升级，请在升级Compose后删除或迁移现有容器。这是因为，从版本1.3开始，Compose使用Docker标签来跟踪容器，并且需要重新创建容器以添加标签。

如果Compose检测到没有标签创建的容器，它将拒绝运行，因此您最终不会使用两组。如果要继续使用现有容器（例如，因为它们具有要保留的数据卷），可以使用Compose 1.5.x使用以下命令迁移它们：

```
docker-compose migrate-to-labels
```

或者，如果您不担心保留它们，可以将它们删除。撰写只是创建新的。

```
docker container rm -f -v myapp_web_1 myapp_db_1 ...

```

### 卸载

如果安装使用，则卸载Docker Compose curl：
```
sudo rm /usr/local/bin/docker-compose
```
如果安装使用，则卸载Docker Compose pip：

```
pip uninstall docker-compose
```
