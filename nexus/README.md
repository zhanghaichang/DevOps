# nexus maven 安装

### Docker 安装

```
sudo docker run -d --name nexus3 --restart=always -p 8081:8081 -v /data/nexus:/nexus-data  sonatype/nexus3:3.14.0
```
