
## jenkins dockerfile

```shell
FROM jenkins/jenkins:lts
USER root
RUN echo deb http://mirrors.aliyun.com/debian wheezy main contrib non-free \
    deb-src http://mirrors.aliyun.com/debian wheezy main contrib non-free \
    deb http://mirrors.aliyun.com/debian wheezy-updates main contrib non-free \
    deb-src http://mirrors.aliyun.com/debian wheezy-updates main contrib non-free \
    deb http://mirrors.aliyun.com/debian-security wheezy/updates main contrib non-free \
    deb-src http://mirrors.aliyun.com/debian-security wheezy/updates main contrib non-free \
    > /etc/apt/sources.list \
    && apt update \
    && apt install -y libltdl-dev
    
```
### docker build

> docker build -t jenkins:latest .


## jenkins docker 安装:
> docker run -p 9090:8080 -p 50000:50000  --privileged=true  -v /var/jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/bin/docker --name my_jenkins -d jenkins/jenkins:lts

