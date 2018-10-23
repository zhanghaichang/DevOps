# Jenkins 安装教程

## docker install 

```
docker pull jenkins
```

## docker run

```
docker run -p 8080:8080 -p 50000:50000 -v /root/home/jenkins/:/var/jenkins_home jenkins
```
