```groovy
node{
    stage('get clone'){
        //check CODE
       git credentialsId: 'github', url: 'https://github.com/zhanghaichang/jenkins-demo.git'
    }

    //定义mvn环境
    def mvnHome = tool 'M3'
    env.PATH = "${mvnHome}/bin:${env.PATH}"

    stage('mvn test'){
        //mvn 测试
        sh "mvn test"
    }

    stage('mvn build'){
        //mvn构建
        sh "mvn clean install -Dmaven.test.skip=true"
    }

    stage('deploy'){
        //执行部署脚本
        echo "deploy ......" 
        sh "docker build -t zhanghaichang/springboot-helloworld:20180809-0001 ."
        sh "docker login -u zhanghaichang@163.com -p zhanghaichang521 https://hub.docker.com/"
        sh "docker tag 20180809-0001 zhanghaichang/springboot-helloworld"
        sh "docker push zhanghaichang/springboot-helloworld:20180809-0001"
        
    }
}
```
