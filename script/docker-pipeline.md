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

    stage('docker build'){
        //执行推送
        echo "docker build ......" 
		def image="${name}:${tag}"
        sh "docker build -t ${image} ."
		withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
        sh "docker login -u ${dockerHubUser} -p ${dockerHubPassword}"
        sh "docker push ${image}"
		}
	}
    stage('docker deploy'){
        //执行部署脚本
        echo "docker deploy ......" 
        
    }
}
