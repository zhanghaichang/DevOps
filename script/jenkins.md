docker:
docker run -p 9090:8080 -p 50000:50000 -v /var/jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --name my_jenkins -d jenkins/jenkins:lts
