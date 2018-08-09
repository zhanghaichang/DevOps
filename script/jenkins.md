docker:
docker run -p 9090:8080 -p 50000:50000 -v /var/jenkins:/var/jenkins_home --name my_jenkins -d jenkins/jenkins:lts
