# nexus maven 安装

### Docker 安装

```
sudo docker run -d -p 8081:8081 --restart=always --name nexus -v /data/nexus:/nexus-data sonatype/nexus3:3.14.0
```
