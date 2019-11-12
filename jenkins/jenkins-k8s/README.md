# jenkins kubernetes 

## 整个流程：

* (1)、介绍了如何在 Kubernetes 部署 Jenkins。
* (2)、介绍 Jenkins 中需要安装什么相关插件。
* (3)、配置凭据，例如 Docker 仓库凭据、K8S 连接凭据、Git 认证凭据。
* (4)、在 Jenkins 中存储执行流水线过程中的脚本，例如 Docker 的 Dockerfile、Maven 的 Settings.xml。
* (5)、简介描述了如何写 “脚本式” 的流水线脚本，以及脚本中如何使用各种常用插件。
* (6)、创建一个用于当做模板的 Job，对其进行一些参数化构建变量配置，方便后续全部的 Job 通过复制该模板 Job 来新建。
* (7)、写流水线脚本，将分为 Git、Maven、Docker、Kubectl、Http 等几个阶段。写完脚本后放置到上面创建模板 Job 的脚本框框中。
* (8)、通过复制模板 Job 来新创建用于测试的项目 Job，并且修改其中从模板 Job 复制过来的变量的参数，将其改成适用于该测试项目的参数值。
* (9)、执行上面创建的测试项目的 Job，观察它是否能够正常执行完整个脚本，并且结果为成功。


## 一、Kubernetes 部署 Jenkins

下面是以 NFS 为存储卷的示例，将在 NFS 存储卷上创建 Jenkins 目录，然后创建 NFS 类型的 PV、PVC。

### 1、NFS 存储卷创建 Jenkins 目录

进入 NFS Server 服务器，然后再其存储目录下创建 Jenkins 目录，并且确保目录对其它用户有读写权限。

    $ mkdir /nfs/data/jenkins

### 2、创建 Jenkins 用于存储的 PV、PVC

创建 Kubernetes 的 PV、PVC 资源，其中 PV 用于与 NFS 关联，需要设置 NFS Server 服务器地址和挂载的路径，修改占用空间大小。而 PVC 则是与应用关联，方便应用与 NFS 绑定挂载，下面是 PV、PVC 的资源对象 yaml 文件。

**jenkins-storage.yaml**

    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: jenkins
      labels:
        app: jenkins
    spec:
      capacity:
        storage: 50Gi
      accessModes:
        - ReadWriteOnce
      persistentVolumeReclaimPolicy: Retain
      mountOptions:         #NFS挂在选项
        - hard
        - nfsvers=4.1
      nfs:                  #NFS设置
        path: /nfs/data/jenkins
        server: 192.168.2.11
    ---
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
      name: jenkins
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 50Gi     #存储空间大小
      selector:
        matchLabels:
          app: jenkins

将 PV 与 PVC 部署到 Kubernetes 中：

- -n：指定 namespace

  \$ kubectl apply -f jenkins-storage.yaml -n public

### 3、创建 ServiceAccount & ClusterRoleBinding

Kubernetes 集群一般情况下都默认开启了 RBAC 权限，所以需要创建一个角色和服务账户，设置角色拥有一定权限，然后将角色与 ServiceAccount 绑定，最后将 ServiceAccount 与 Jenkins 绑定，这样来赋予 Jenkins 一定的权限，使其能够执行一些需要权限才能进行的操作。这里为了方便，将 cluster-admin 绑定到 ServiceAccount 来保证 Jenkins 拥有足够的权限。

- **注意：** 请修改下面的 Namespace 参数，改成部署的 Jenkins 所在的 Namespace。

**jenkins-rbac.yaml**

    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: jenkins-admin       #ServiceAccount名
      namespace: mydlqcloud     #指定namespace，一定要修改成你自己的namespace
      labels:
        name: jenkins
    ---
    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: jenkins-admin
      labels:
        name: jenkins
    subjects:
      - kind: ServiceAccount
        name: jenkins-admin
        namespace: mydlqcloud
    roleRef:
      kind: ClusterRole
      name: cluster-admin
      apiGroup: rbac.authorization.k8s.io

将 Jenkins 的 RBAC 部署到 Kubernetes 中：

- -n：指定 namespace

  \$ kubectl apply -f jenkins-rbac.yaml -n public

### 4、创建 Service & Deployment

在 Kubernetes 中部署服务需要部署文件，这里部署 Jenkins 需要创建 Service 与 Deployment 对象，其中两个对象需要做一些配置，如下：

- Service：Service 暴露两个接口 `8080` 与 `50000`，其中 8080 是 Jenkins API 和 UI 的端口，而 50000 则是供代理使用的端口。
- Deployment： Deployment 中，需要设置容器安全策略为 `runAsUser: 0` 赋予容器以 `Root` 权限运行，并且暴露 `8080` 与 `50000` 两个端口与 Service 对应，而且还要注意的是，还要设置上之前创建的服务账户 “jenkins-admin”。

**jenkins-deployment.yaml**

    apiVersion: v1
    kind: Service
    metadata:
      name: jenkins
      labels:
        app: jenkins
    spec:
      type: NodePort
      ports:
      - name: http
        port: 8080                      #服务端口
        targetPort: 8080
        nodePort: 32001                 #NodePort方式暴露 Jenkins 端口
      - name: jnlp
        port: 50000                     #代理端口
        targetPort: 50000
        nodePort: 32002
      selector:
        app: jenkins
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: jenkins
      labels:
        app: jenkins
    spec:
      selector:
        matchLabels:
          app: jenkins
      replicas: 1
      template:
        metadata:
          labels:
            app: jenkins
        spec:
          serviceAccountName: jenkins-admin
          containers:
          - name: jenkins
            image: jenkins/jenkins:2.199
            securityContext:
              runAsUser: 0                      #设置以ROOT用户运行容器
              privileged: true                  #拥有特权
            ports:
            - name: http
              containerPort: 8080
            - name: jnlp
              containerPort: 50000
            resources:
              limits:
                memory: 2Gi
                cpu: "2000m"
              requests:
                memory: 2Gi
                cpu: "2000m"
            env:
            - name: LIMITS_MEMORY
              valueFrom:
                resourceFieldRef:
                  resource: limits.memory
                  divisor: 1Mi
            - name: "JAVA_OPTS"                 #设置变量，指定时区和 jenkins slave 执行者设置
              value: "
                       -Xmx$(LIMITS_MEMORY)m
                       -XshowSettings:vm
                       -Dhudson.slaves.NodeProvisioner.initialDelay=0
                       -Dhudson.slaves.NodeProvisioner.MARGIN=50
                       -Dhudson.slaves.NodeProvisioner.MARGIN0=0.85
                       -Duser.timezone=Asia/Shanghai
                     "
            - name: "JENKINS_OPTS"
              value: "--prefix=/jenkins"         #设置路径前缀加上 Jenkins
            volumeMounts:                        #设置要挂在的目录
            - name: data
              mountPath: /var/jenkins_home
          volumes:
          - name: data
            persistentVolumeClaim:
              claimName: jenkins                 #设置PVC

**参数说明：**

- **JAVA_OPTS：** JVM 参数设置
- **JENKINS_OPTS：** Jenkins 参数设置
- **其它参数：** 默认情况下，Jenkins 生成代理是保守的。例如，如果队列中有两个构建，它不会立即生成两个执行器。它将生成一个执行器，并等待某个时间释放第一个执行器，然后再决定生成第二个执行器。Jenkins 确保它生成的每个执行器都得到了最大限度的利用。如果你想覆盖这个行为，并生成一个执行器为每个构建队列立即不等待，所以在 Jenkins 启动时候添加这些参数:

  -Dhudson.slaves.NodeProvisioner.initialDelay=0
  -Dhudson.slaves.NodeProvisioner.MARGIN=50
  -Dhudson.slaves.NodeProvisioner.MARGIN0=0.85

有了上面的部署文件后，再将 Jenkins 部署到 Kuberntes 中：

- -n：指定应用启动的 namespace

  \$ kubectl create -f jenkins-deployment.yaml -n mydlqcloud

### 5、获取 Jenkins 生成的 Token

在安装 Jenkins 时候，它默认生成一段随机字符串在控制台日志中，用于安装时验证。这里需要获取它输出在控制台中的日志信息，来获取 Token 字符串。

**查看 Jenkins Pod 启动日志**

- -n：指定应用启动的 namespace

  $ kubectl log $(kubectl get pods -n mydlqcloud | awk '{print \$1}' | grep jenkins) -n mydlqcloud

**在日志中可以看到，默认给的 token 为：**

    *************************************************************
    Jenkins initial setup is required. An admin user has been created and a password generated.
    Please use the following password to proceed to installation:

    96b19967a2aa4e7ab7d2ea5c6f55db8d

    This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
    *************************************************************

### 6、启动 Jenkins 进行初始化

输入 Kubernetes 集群地址和 Jenkins Service 设置的 NodePort 端口号，访问 Jenkins UI 界面进行初始化，按以下步骤执行：

**进入 Jenkins**

输入 Kubernetes 集群地址和上面设置的 `Nodeport` 方式的端口号 `32001`，然后输入上面获取的 `Token` 字符串。例如，本人 Kubernetes 集群 IP 为 `192.168.2.11` ，所以就可以访问地址 `http://192.168.2.11:32001/jenkins` 进入 Jenkins 初始化界面。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-1002.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-1002.png)

**安装插件**

安装插件，选择 `推荐安装` 方式进行安装即可，后续再安装需要的插件。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-1003.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-1003.png)

**设置用户名、密码**

在这里输入一个用户名、密码，方便后续登录，如果不设置可能下次登录需要使用之前日志中默认的 Token 串来登录。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-1004.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-1004.png)

**配置 Jenkins 地址**

配置 Jenkins URL 地址，来告知 Jenkins 自己的 URL，在发送邮件、触发钩子等可能用到。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-1005.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-1005.png)

**进入 Jenkins 界面**

到此 Jenkins 初始化就配置完成，成功进入 Jenkins 界面。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-1006.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-1006.png)

## 二、Jenkins 安装相关插件

Jenkins 中可以打开 **系统管理->插件管理->可选插件** 来安装下面的一些插件：

- **Git：** Jenkins 安装中默认安装 Git 插件，所以不需要单独安装。利用 git 工具可以将 github、gitlab 等等的地址下载源码。
- **Docker：** Jenkins 安装中默认安装 Docker 插件，所以不需要单独安装。利用 Docker 插件可以设置 Docker 环境，运行 Docker 命令，配置远程 Docker 仓库凭据等。
- **Kubernetes：** Kubernetes 插件的目的是能够使用 Kubernetes 集群动态配置 Jenkins 代理（使用 Kubernetes 调度机制来优化负载），运行单个构建，等构建完成后删除该代理。这里我们需要用到这个插件来启动 Jenkins Slave 代理镜像，让代理执行 Jenkins 要执行的 Job。
- **Kubernetes Cli：** Kubernetes Cli 插件作用是在执行 Jenkins Job 时候提供 kubectl 与 Kubernetes 集群交互环境。可以在 Pipeline 或自由式项目中允许执行 kubectl 相关命令。它的主要作用是提供 kubectl 运行环境，当然也可以提供 helm 运行环境。
- **Config File Provider：** Config File Provider 插件作用就是提供在 Jenkins 中存储 properties、xml、json、settings.xml 等信息，可以在执行 Pipeline 过程中可以写入存储的配置。例如，存入一个 Maven 全局 Settings.xml 文件，在执行 Pipeline Job 时候引入该 Settings.xml ，这样 Maven 编译用的就是该全局的 Settings.xml。
- **Pipeline Utility Steps：** 这是一个操作文件的插件，例如读写 json、yaml、pom.xml、Properties 等等。在这里主要用这个插件读取 pom.xml 文件的参数设置，获取变量，方便构建 Docker 镜像。
- **Git Parameter：** 能够与 Git 插件结合使用，动态获取 Git 项目中分支信息，在 Jenkins Job 构建前提供分支选项，来让项目执行人员选择拉取对应分支的代码。

## 三、配置相关凭据

选择 **凭据->系统->全局凭据->添加凭据** 来新增 Git、Docker Hub、Kubernetes 等认证凭据。

### 1、添加 Git 认证凭据

**配置的参数值：**

- 类型：Username with password
- 范围：全局
- 用户名（Git 用户名）： 略
- 密码（Git 密码）：略
- ID：global-git-credential
- 描述：全局 Git 凭据

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-credential-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-credential-1.png)

### 2、添加 Kubernetes Token 凭据

**配置的参数值：**

- 类型：Secret text
- 范围：全局
- Secret（K8S Token 串）：略
- ID：global-kubernetes-credential
- 描述：全局的 K8S Token

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-credential-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-credential-2.png)

### 3、添加 Docker 仓库认证凭据

**配置的参数值：**

- 类型：Username with password
- 范围：全局
- 用户名（Docker 仓库用户名）：略
- 密码（Docker 仓库密码）：略
- ID：docker-hub-credential
- 描述：Docker 仓库认证凭据

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-credential-3.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-credential-3.png)

## 四、Jenkins 配置 Kubernetes 插件

进入 **系统管理->系统设置->云** 中，点击 **新增一个云** 选项，来新建一个与 Kubernetes 的连接，然后按照下面各个配置项进行配置。

### 1、Kubernetes Plugin 基本配置

#### (1)、配置连接 Kubernetes 参数

配置 Kubernetes API 地址，然后再选择 Kubernetes Token 凭据。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-connection-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-connection-1.png)

**注意：** 如果你的 Jenkins 也是安装在 Kubernetes 环境中，那么可以直接使用 Kubernetes 集群内的 Kubernetes API 地址，如果 Jnekins 是在安装在正常物理机或者虚拟机环境中，那么使用集群外的 Kubernetes API 地址，两个地址如下：

- 集群内地址：[https://kubernetes.default.svc.cluster.local](https://kubernetes.default.svc.cluster.local)
- 集群外地址：https://{Kubernetes 集群 IP}:6443

然后点击连接测试，查看是否能成功连通 Kubernetes，如果返回结果 Successful 则代表连接成功，否则失败。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-connection-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-connection-2.png)

#### (2)、配置 Jenkins 地址

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-jenkins-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-jenkins-1.png)

**注意：** 这里的 Jenkins 地址是供 Slave 节点连接 Jenkins Master 节点用的，所以这里需要配置 Jenkins Master 的 URL 地址。这里和上面一样，也是考虑 Jenkins 是部署在 Kubernetes 集群内还是集群外，两个地址如下：

- 集群内地址：https://{Jenkins Pod 名称}.{Jenkins Pod 所在 Namespace}/{Jenkins 前缀}
- 集群外地址：https://{Kubernetes 集群 IP}:{Jenkins NodePort 端口}/{Jenkins 前缀}

> 如果 Jnekins 中配置了 /jenkins 前缀，则 URL 后面加上 /jenkins，否则不加，这个地址根据自己的 Jnekins 实际情况来判断。

### 2、Kubernetes 插件 Pod 模板配置

#### (1)、配置 Pod 名称和标签列表

配置 Pod 模板的名称和标签列表名，Pod 模板名可用于子模板继承，标签列表可用于 Jenkins Job 中指定，使用此 Pod 模板来执行任务。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-template-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-template-1.png)

#### (2)、配置 Pod 的原始 yaml

在 Pod 的原始 yaml 配置中，加入一段配置，用于改变 Kubernetes Plugin 自带的 JNLP 镜像，并指定 RunAsUser=0 来使容器以 Root 身份执行任务，并设置 privileged=true 来让 Slave Pod 在 Kubernetes 中拥有特权。

> Jenkins Slave JNLP 镜像官方地址 [https://hub.docker.com/r/jenkins/slave](https://hub.docker.com/r/jenkins/slave) 可以从中下载相关 JNLP 代理镜像。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-template-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-template-2.png)

yaml 内容如下：

    apiVersion: v1
    kind: Pod
    metadata:
      labels:
        app: jenkins-slave
    spec:
      securityContext:
        runAsUser: 0
        privileged: true
      containers:
      - name: jnlp
        tty: true
        workingDir: /home/jenkins/agent
        image: registry.cn-shanghai.aliyuncs.com/mydlq/jnlp-slave:3.35-5-alpine

### 3、Kubernetes 插件 Container 配置

将配置 Jenkins Slave 在 Kubernetes 中的 Pod 中所包含容器信息，这里镜像都可以从官方 Docker Hub 下载，由于网速原因，本人已经将其下载到 Aliyun 镜像仓库。

#### (1)、配置 Maven 镜像

- 名称：maven
- Docker 镜像：registry.cn-shanghai.aliyuncs.com/mydlq/maven:3.6.0-jdk8-alpine
- 其它参数：默认值即可

> Maven 镜像可以从官方 Docker Hub 下载，地址：[https://hub.docker.com/\_/maven](https://hub.docker.com/_/maven)

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-container-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-container-1.png)

#### (2)、配置 Docker In Docker 镜像

- 名称：docker
- Docker 镜像：registry.cn-shanghai.aliyuncs.com/mydlq/docker:18.06.3-dind
- 其它参数：默认值即可

> Docker-IN-Docker 镜像可以从官方 Docker Hub 下载，地址：[https://hub.docker.com/\_/docker](https://hub.docker.com/_/docker)

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-container-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-container-2.png)

#### (3)、配置 Kubectl 镜像

- 名称：kubectl
- Docker 镜像：registry.cn-shanghai.aliyuncs.com/mydlq/kubectl:1.15.3
- 其它参数：默认值即可

> Kubectl 镜像可以从官方 Docker Hub 下载，地址：[https://hub.docker.com/r/bitnami/kubectl](https://hub.docker.com/r/bitnami/kubectl)

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-container-3.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-container-3.png)

### 4、Container 存储挂载配置

由于上面配置的 Maven、Docker 等都需要挂载存储，Maven 中是将中央仓库下载的 Jar 存储到共享目录，而 Docker 则是需要将宿主机的 Docker 配置挂载到 Docker In Docker 容器内部，所以我们要对挂载进行配置。

#### (1)、创建 Maven 存储使用的 PV、PVC

提前在 NFS 卷中，创建用于存储 Maven 相关 Jar 的目录：

> 创建的目录要确保其它用户有读写权限。

    $ mkdir /nfs/data/maven

然后，Kubernetes 下再创建 Maven 的 PV、PVC 部署文件：

**maven-storage.yaml**

    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: maven
      labels:
        app: maven
    spec:
      capacity:
        storage: 100Gi
      accessModes:
        - ReadWriteOnce
      persistentVolumeReclaimPolicy: Retain
      mountOptions:         #NFS挂在选项
        - hard
        - nfsvers=4.1
      nfs:                  #NFS设置
        path: /nfs/data/maven
        server: 192.168.2.11
    ---
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
      name: maven
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 100Gi     #存储空间大小
      selector:
        matchLabels:
          app: maven

部署 PV、PVC 到 Kubernetes 中：

- -n：指定 namespace

  \$ kubectl apply -f maven-storage.yaml -n public

#### (2)、配置 Maven 挂载

在卷选项中，选择添加卷，选择 `Persistent Volume Claim` 按如下添加配置：

- 申明值（PVC 名称）：maven
- 挂在路径（容器内的目录）：/root/.m2

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-container-volume-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-container-volume-1.png)

#### (3)、配置 Docker 挂载

Kubernetes 中 Pod 的容器是启动在各个节点上，每个节点就是一台宿主机，里面进行了很多 Docker 配置，所以我们这里将宿主机的 Docker 配置挂载进入 Docker 镜像。选择添加卷，选择 `Host Path Volume` 按如下添加配置：

**① 路径 /usr/bin/docker：**

- 主机路径（宿主机目录）：/usr/bin/docker
- 挂载路径（容器内的目录）：/usr/bin/docker

**② 路径 /var/run/docker.sock：**

- 主机路径（宿主机目录）：/var/run/docker.sock
- 挂载路径（容器内的目录）：/var/run/docker.sock

**③ 路径 /etc/docker：**

- 主机路径（宿主机目录）：/etc/docker
- 挂载路径（容器内的目录）：/etc/docker

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-container-volume-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-kubernetes-plugin-pod-container-volume-2.png)

## 五、创建相关文件

之前安装了 **Config File Provider** 插件，该插件功能就是可以在 Jenkins 上存储一些配置文件，例如，我们经常使用到的 yaml、properties、Dockerfile、Maven 的 Settings.xml 等文件，都可以存储到 Jenkins 该插件中。

打开 **系统管理->Managed files** ，在其中新增几个文件：

- **Maven 配置文件：** Maven 的 Settings.xml 配置文件。
- **Dockerfile 文件：** Dockerfile 脚本。
- **Kubernetes 部署文件：** 将应用部署到 kubernetes 的 Deployment 文件。

### 1、新增 Maven 配置文件

选择 **Add a new Config—>Global Maven settings.xml** 来新增一个 **Maven** 全局 **Settings.xml** 文件：

- **ID：** global-maven-settings
- **Name：** MavenGlobalSettings
- **Comment：** 全局 Maven Settings.xml 文件
- **Content：** 内容如下 ↓：

> 为了加快 jar 包的下载速度，这里将仓库地址指向 aliyun Maven 仓库地址。

    <?xml version="1.0" encoding="UTF-8"?>

    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

      <pluginGroups>
      </pluginGroups>

      <proxies>
      </proxies>

      <servers>
      </servers>

      <mirrors>
        <!--Aliyun Maven-->
        <mirror>
            <id>alimaven</id>
            <name>aliyun maven</name>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
      </mirrors>

      <profiles>
      </profiles>

    </settings>

### 2、新增 Dockerfile 文件

选择 **Add a new Config—>Custom file** 来新增一个 **Dockerfile** 文件：

- **ID：** global-dockerfile-file
- **Name：** Dockerfile
- **Comment：** 全局 Dockerfile 文件
- **Content：** 内容如下 ↓：

  FROM openjdk:8u222-jre-slim
  VOLUME /tmp
  ADD target/\*.jar app.jar
  RUN sh -c 'touch /app.jar'
  #JAVA JVM 参数
  ENV JAVA_OPTS="-Duser.timezone=Asia/Shanghai"
  #Java 应用参数
  ENV APP_OPTS=""
  ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar $APP_OPTS" ]

### 3、新增 Kubernetes 部署文件

选择 **Add a new Config—>Custom file** 来新增一个 **Kubernetes 部署文件**：

- **ID：** global-kubernetes-deployment
- **Name：** deployment.yaml
- **Comment：** 全局 Kubernetes 部署文件
- **Content：** 内容如下 ↓：

  apiVersion: v1
  kind: Service
  metadata:
  name: #APP_NAME
  labels:
  app: #APP_NAME
  spec:
  type: NodePort
  ports:

  - name: server #服务端口
    port: 8080  
    targetPort: 8080
  - name: management #监控及监控检查的端口
    port: 8081
    targetPort: 8081
    selector:
    app: #APP_NAME

  ***

  apiVersion: apps/v1
  kind: Deployment
  metadata:
  name: #APP_NAME
  labels:
  app: #APP_NAME
  spec:
  replicas: #APP_REPLICAS
  selector:
  matchLabels:
  app: #APP_NAME
  strategy:
  type: Recreate #设置更新策略为删除策略
  template:
  metadata:
  labels:
  app: #APP_NAME
  spec:
  containers: - name: #APP_NAME
  image: #APP_IMAGE_NAME
  imagePullPolicy: Always
  ports: - containerPort: 8080 #服务端口
  name: server - containerPort: 8081 #监控及监控检查的端口
  name: management
  env:
  name: "update_uuid"
  value: "#APP_UUID" #生成的随机值，放置执行 kubectl apply 时能够执行
  resources:
  limits:
  cpu: 2000m
  memory: 1024Mi
  requests:
  cpu: 1000m
  memory: 512Mi

为了模板能够动态替换某些值，上面模板中设置了几个可替换的参数，用 **#变量名称** 来标记，后面我们在执行 Pipeline 时候将里面的 **#xxx 变量** 标记替换掉，上面配置的变量有：

- **#APP_NAME：** 应用名称。
- **#APP_REPLICAS：** 应用副本数。
- **#APP_IMAGE_NAME：** 镜像名称。
- **#APP_UUID：** 生成的随机值，因为后续 Kubectl 在执行命令时候，如果部署对象中的值没有一点变化的话，将不会执行 kubectl apply 命令，所以这里设置了一个随机值，以确保每次部署文件都不一致。

并且还有一点就是要注意，设置更新策略为 Recreate（删除再创建） 策略，否则后面的健康检查阶段将不能正常检查更新后的项目。

> Kubernetes 默认为 RollingUpdate 策略，该策略为应用启动时，先将新实例启动，再删除旧的实例，就是因为这样，在后面健康检查阶段，健康检查 URL 地址还是未更新前的旧实例的 URL 地址，会导致健康检查不准确，所以必须改为 Recreate 策略，先删除旧实例，再创建新实例。

## 六、如何写流水线脚本和使用插件

### 1、脚本中设置全局超时时间

设置任务超时时间，如果在规定时间内任务没有完成，则进行失败操作，格式如下：

    timeout(time: 60, unit: 'SECONDS') {
        // 脚本
    }

### 2、脚本中使用 Git 插件

Git 插件方法使用格式，及其部分参数：

- **changelog：** 是否检测变化日志
- **url：** Git 项目地址
- **branch：** Git 分支
- **credentialsId：** Jenkins 存的 Git 凭据 ID 值

  git changelog: true,
  url: "http://gitlab.xxxx/xxx.git"
  branch: "master",
  credentialsId: "xxxx-xxxx-xxxx-xxxx",

### 3、脚本中使用 Kubernetes 插件

Kubernetes 插件中存在 PodTemplate 方法，在执行脚本时候，会自动在 Kubernetes 中创建 Pod Template 配置的 Slave Pod，在其中执行 podTemplate 代码块中的脚本。

    def label = "jnlp-agent"
    podTemplate(label: label,cloud: 'kubernetes' ){
        node (label) {
            print "在 Slave Pod 中执行任务"
        }
    }

**podTemplate 方法参数简介：**

- **cloud：** 之前 Kuberntes 插件配置的 Cloud 名称
- **label：** 之前 Kuberntes 插件配置的 Cloud 中 Pod Template 里面的 Label 标签名称。

### 4、脚本中使用 Docker 镜像

在之前配置了 Kubernetes 插件的 Pod Template 配置中，配置了几个容器，每个容器中都有特定的功能的环境，例如：

- Maven 容器中能够执行 mvn 命令。
- Kuberctl 容器能够执行 kubectl 命令。
- Docker In Docker 容器中能够执行 Docker 命令。

既然每个容器都能提供特定的环境，那么再执行执行 Pipleline 脚本时候，就可以在不同的镜像中使用不同的环境的命令：

- **Maven 镜像**

  container('maven') {  
   sh "mvn install
  }

* **Docker In Docker 镜像**

  container('docker') {  
   sh "docker build -t xxxxx:1.0.0 .
  }

- **Kubectl 镜像**

  container('kubectl') {  
   sh "kubectl apply -f xxxx.yaml"
  }

### 5、脚本中引入 Jenkins 中预先存储的文件

在之前的 **系统设置->File Manager** 中，存储了很多文件，例如：

- Docker 的镜像构建脚本文件 Dockerfile。
- Maven 的全局设置文件 Settings.xml
- Kubernetes 的部署文件 deployment.yaml

在使用 Pipleline 脚本时候，我们需要将这些文件文本提取出来，创建在执行任务的流程中，创建这些文件可以使用 Config File Provider 插件提供的 configFileProvider 方法，李如意：

- **创建 settings.xml 文件**

  configFileProvider([configFile(fileId: "global-maven-settings", targetLocation: "settings.xml")]){
  sh "cat settings.xml"
  }

* **创建 Dockerfile 文件**

  configFileProvider([configFile(fileId: "global-dockerfile-file", targetLocation: "Dockerfile")]){
  sh "cat Dockerfile"
  }

- **创建 Dockerfile 文件**

  configFileProvider([configFile(fileId: "global-kubernetes-deployment", targetLocation: "deployment.yaml")]){
  sh "cat deployment.yaml"
  }

### 6、脚本创建文件

在使用 Groovy 写 Pipleline 脚本时候，经常要将变量的文本生成文件，方便在执行流水线过程中操作文本文件使用，如何将文件转换为文件，可以使用 Pipeline Utility Steps 插件的 writeFile 方法，如下：

    writeFile encoding: 'UTF-8', file: './test.txt', text: "写入文件的文本内容"

### 7、脚本中使用 Http Rrequest 插件

脚本中可以使用 HttpRequest 来对某一地址进行请求，这里简单使用 Get 请求地址，复杂的可以查看 Jenkins 插件的官网查看使用示例。

下面是使用 Http Request 的 Get 请求示例：

    result = httpRequest "http:www.baidu.com"

    if ("${result.status}" == "200") {
        print "Http 请求成功"
    }

### 8、脚本中使用 Kubernetes Cli 插件

在之前说过，在 kubectl 镜像中能够使用 kubectl 命令，不过由于执行 Kubectl 命令一般需要在镜像的 **\$HOME/.kube/** 目录中存在连接 **Kubernetes API** 的 **config** 文件，使其 **kubectl** 命令有明确请求 **kubernetes API** 的地址和用户权限，不过将 **config** 文件挂入镜像内部是一件比较繁琐的事情。

好在 **Jenkins** 提供的 **Kubectl Cli** 插件，只要在其中配置连接 **Kubernetes 的 Token** 凭据，就能够在 **Kubectl Cli** 提供的 **withKubeConfig** 方法，拥有类似存在 **config** 一样的功能，在 **kubectl** 镜像中的 **withKubeConfig** 方法块内执行 **kubectl** 就可以操作配置的 **Kubectl Cli** 的凭据的 **K8S** 集群。

    container('kubectl') {
        withKubeConfig([credentialsId: "Kubernetes Token 凭据 ID",serverUrl: "https://kubernetes.default.svc.cluster.local"]) {
            sh "kubectl get nodes"
        }
    }

### 9、脚本中操作字符串替换值

在使用 Groovy 语法写 Pipleline 脚本时候，我们经常要替换先前设置好的一些文本的值，这里我们简单示例一下，如何替换字符串。

    // 测试的字符串
    sourceStr = "这是要替换的值：#value1，这是要替换的值：#value2"
    // 替换#value1与#value2连个值
    afterStr = deploy.replaceAll("#value1","AAA").replaceAll("#value2","BBB")
    // 输出替换后的字符串
    print "${afterStr}"

### 10、脚本中读取 pom.xml 参数

在执行 Java 项目的流水线时，我们经常要动态获取项目中的属性，很多属性都配置在项目的 pom.xml 中，还好 Pipeline Utility Steps 插件提供能够读取 pom.xml 的方法，示例如下：

    stage('读取pom.xml参数阶段'){
        // 读取 Pom.xml 参数
        pom = readMavenPom file: './pom.xml'
        // 输出读取的参数
        print "${pom.artifactId}"
        print = "${pom.version}"
    }

### 11、脚本中使用 Docker 插件构建与推送镜像

在流水线脚本中，我们一般不直接使用 Docker 命令，而是使用 Docker 插件提供的 docker.withRegistry(“”) 方法来构建与推送镜像，并且还能在方法中配置登录凭据信息，来让仓库验证权限，这点是非常方便的。使用示例如下：

    docker.withRegistry("http://xxxx Docker 仓库地址", "Docker 仓库凭据 ID") {
            // 构建 Docker 镜像
            def customImage = docker.build("${dockerImageName}")
            // 推送 Docker 镜像
            customImage.push()
        }

## 七、在 Jenkins 创建模板任务

创建一个 Pipeline Job 来充当各个 Jenkins Job 的模板，方便后续创建 Job 时，直接复制模板项目，然后修改配置就能使用。所以这里我们创建一个模板 Pipeline Job，在 Job 配置中需要添加一些参数和环境变量，方便我们动态替换一些值。

### 1、创建 Pipeline 任务

- **任务名称：** my-template
- **任务类型：** 流水线项目

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-job-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-job-1.png)

### 2、配置项目构建基本参数

配置同一时间一个 Job 只能构建一个，不允许多个并发构建。另外需要设置项目构建后，包的保留时间，以防止包过多且大占用大量空间（一个包很肯能占 10MB~200MB 大小）导致储不足。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-job-base-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-job-base-1.png)

### 3、配置 Git 变量

在 Job 配置的 **参数化构建过程** 中，添加下面参数：

**Git 项目地址变量**

- 变量名称：GIT_PROJECT_URL
- 类型：String
- 描述：项目 Git 地址
- 默认值：”[https://xxxxxxxxxxxx"](https://xxxxxxxxxxxx")

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-git-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-git-1.png)

**Git 分支变量**

- 变量名称：GIT_BRANCH
- 类型：Git Parameter
- 描述：选择 Git 分支
- 默认值：master

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-git-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-git-2.png)

**Git 凭据变量**

- 变量名称：GIT_CREADENTIAL
- 类型：Credentials
- 描述：Git 凭据
- 默认值：global-git-credential

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-git-3.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-git-3.png)

### 4、配置 Maven 变量

**Maven 构建命令变量**

- 变量名称：MAVEN_BUILD_OPTION
- 类型：Choices
- 描述：要执行的执行 Maven 命令选择
- 可选值：\[‘package’, ‘install’, ‘deploy’\]
- 默认值：install

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-maven-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-maven-1.png)

### 5、配置 Docker 变量

**Docker 项目地址变量**

- 变量名称：DOCKER_HUB_URL
- 类型：String
- 描述：Docker 仓库地址
- 默认值（默认 Docker 仓库地址）：”10.71.164.28:5000”

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-docker-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-docker-1.png)

**Docker 仓库项目组变量**

- 变量名称：DOCKER_HUB_GROUP
- 类型：String
- 描述：Docker 仓库项目组名
- 默认值：””

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-docker-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-docker-2.png)

**Docker 仓库认证凭据变量**

- 变量名称：DOCKER_HUB_CREADENTIAL
- 类型：Credentials
- 描述：Docker 仓库认证凭据
- 默认值：docker-hub-credential

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-docker-3.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-docker-3.png)

**Docker Dockerfile 文件 ID 变量**

- 变量名称：DOCKER_HUB_GROUP
- 类型：String
- 描述：存于 Jenkins “Managed files” 的 Dockerfile 文件的 ID
- 默认值：”global-dockerfile-file”

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-docker-4.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-docker-4.png)

### 6、配置 Kubernetes 变量

**Kubernetes 认证凭据变量**

- 变量名称：KUBERNETES_CREADENTIAL
- 类型：Credentials
- 描述：Kubernetes 认证 Token
- 默认值：global-kubernetes-credential

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-k8s-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-k8s-1.png)

**Kubernetes Namespace 变量**

- 变量名称：KUBERNETES_NAMESPACE
- 类型：String
- 描述：Kubernetes 命名空间 Namespace
- 默认值：””

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-k8s-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-k8s-2.png)

**Kubernetes 应用实例副本数**

- 变量名称：KUBERNETES_APP_REPLICAS
- 类型：String
- 描述：应用实例副本数
- 默认值：1

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-k8s-3.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-k8s-3.png)

**Kubernetes 应用部署 yaml 文件 ID**

- 变量名称：KUBERNETES_DEPLOYMENT_ID
- 类型：String
- 描述：存于 Jenkins “Managed files” 的 K8S 部署文件的 ID
- 默认值：”global-kubernetes-deployment”

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-k8s-4.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-k8s-4.png)

### 7、配置 HTTP 变量

**HTTP 健康检查端口**

- 变量名称：HTTP_REQUEST_PORT
- 类型：String
- 描述：Http Request 端口（健康检测端口）
- 默认值：8081

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-http-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-http-1.png)

**HTTP 健康检查地址**

- 变量名称：HTTP_REQUEST_URL
- 类型：String
- 描述：Http Request 项目中的相对路径（健康检测路径）
- 默认值：/actuator/health

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-http-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-http-2.png)

**HTTP 健康检查次数**

- 变量名称：HTTP_REQUEST_NUMBER
- 类型：Choices
- 描述：Http Request 请求次数
- 可选值：\[‘10’, ‘5’, ‘10’, ‘15’, ‘20’, ‘25’, ‘30’\]
- 默认值：10

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-http-3.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-http-3.png)

**HTTP 健康检查时间间隔**

- 变量名称：HTTP_REQUEST_INTERVAL
- 类型：Choices
- 描述：Http Request 时间间隔
- 可选值：\[‘10’, ‘5’, ‘15’, ‘20’, ‘25’, ‘30’\]
- 默认值：10

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-http-4.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-template-variate-http-4.png)

## 八、创建 Pipeline 脚本

接下将使用 Groovy 语法创建一个为 SpringBoot 项目准备的 CI/CD 的脚本式的流水线脚本。其中，脚本中包含多个阶段，分别为 Git 拉取镜像，Maven 编译 Java 项目，Docker 构建与推送镜像，Kubectl 部署应用到 Kubernetes 中，最后使用 Http 请求进行健康检查，下面是各个阶段脚本及其介绍。

### 1、脚本中使用 Kubernetes 插件及设置超时时间

使用 Kubernetes 插件执行任务，并设置超时时间为 10 分钟，脚本如下：

    // 设置超时时间 600 SECONDS，方法块内的方法执行超时，任务就标记为失败
    timeout(time: 600, unit: 'SECONDS') {
        def label = "jnlp-agent"

        podTemplate(label: label,cloud: 'kubernetes' ){
            node (label) {
                print "在 Slave Pod 中执行任务"
            }
        }
    }

### 2、脚本中 Git 拉取项目阶段

接下来接着往整体的脚本中添加 Git 模块，其中需要引用上面配置的变量，将变量填入脚本中的方法，如下：

    timeout(time: 600, unit: 'SECONDS') {
        def label = "jnlp-agent"
        podTemplate(label: label,cloud: 'kubernetes' ){
            node (label) {
                stage('Git阶段'){
                    git changelog: true,
                        url: "${params.GIT_PROJECT_URL}"，
                        branch: "${params.GIT_BRANCH}",
                        credentialsId: "${params.GIT_CREADENTIAL}"
                }
            }
        }
    }

**变量介绍：**

- **GIT_BRANCH：** Git 项目分支变量。
- **GIT_PROJECT_URL：** Git 项目 URL 变量。
- **GIT_CREADENTIAL：** Git 凭据 ID 变量。

### 3、脚本中 Maven 编译项目阶段

    timeout(time: 600, unit: 'SECONDS') {
        def label = "jnlp-agent"
        podTemplate(label: label,cloud: 'kubernetes' ){
            node (label) {
                stage('Git阶段'){
                    git changelog: true,
                        url: "${params.GIT_PROJECT_URL}"，
                        branch: "${params.GIT_BRANCH}",
                        credentialsId: "${params.GIT_CREADENTIAL}"
                }
                stage('Maven阶段'){
                    container('maven') {
                        // 创建 Maven 需要的 Settings.xml 文件
                        configFileProvider([configFile(fileId: "global-maven-settings", targetLocation: "settings.xml")]){
                            // 执行 Maven 命令构建项目，并且设置 Maven 配置为刚刚创建的 Settings.xml 文件
                            sh "mvn -T 1C clean ${MAVEN_BUILD_OPTION} -Dmaven.test.skip=true --settings settings.xml"
                        }
                    }
                }
            }
        }
    }

**变量介绍：**

- **MAVEN_BUILD_OPTION：** Maven 执行的构建命令，package、install 或 deploy。
- **global-maven-settings：** 全局 Maven 的 Settings.xml 文件的 ID 值，这里是使用 configFileProvider 插件来创建该文件。

### 4、脚本中读取 pom.xml 参数阶段

这里使用 `Pipeline Utility Steps` 的 `readMavenPom` 方法读取项目的 `pom.xml` 文件，并设置 `appName` 与 `appVersion` 两个全局参数。

    timeout(time: 600, unit: 'SECONDS') {
        def label = "jnlp-agent"
        podTemplate(label: label,cloud: 'kubernetes' ){
            node (label) {
                stage('Git阶段'){
                    git changelog: true,
                        url: "${params.GIT_PROJECT_URL}"，
                        branch: "${params.GIT_BRANCH}",
                        credentialsId: "${params.GIT_CREADENTIAL}"
                }
                stage('Maven阶段'){
                    container('maven') {
                        // 创建 Maven 需要的 Settings.xml 文件
                        configFileProvider([configFile(fileId: "global-maven-settings", targetLocation: "settings.xml")]){
                            // 执行 Maven 命令构建项目
                            sh "mvn -T 1C clean ${MAVEN_BUILD_OPTION} -Dmaven.test.skip=true --settings settings.xml"
                        }
                    }
                }
                stage('读取pom.xml参数阶段'){
                    // 读取 Pom.xml 参数
                    pom = readMavenPom file: './pom.xml'
                    // 设置 appName 和 appVersion 两个全局参数
                    appName = "${pom.artifactId}"
                    appVersion = "${pom.version}"
                }
            }
        }
    }

**变量介绍：**

- **pom.artifactId：** 从 pom.xml 文件中读取的 artifactId 参数值。
- **pom.version：** 从 pom.xml 文件中读取的 version 参数值。

### 5、脚本中 Docker 镜像构建与推送模块

    timeout(time: 600, unit: 'SECONDS') {
        def label = "jnlp-agent"
        podTemplate(label: label,cloud: 'kubernetes' ){
            node (label) {
                stage('Git阶段'){
                    git changelog: true,
                        url: "${params.GIT_PROJECT_URL}"，
                        branch: "${params.GIT_BRANCH}",
                        credentialsId: "${params.GIT_CREADENTIAL}"
                }
                stage('Maven阶段'){
                    container('maven') {
                        // 创建 Maven 需要的 Settings.xml 文件
                        configFileProvider([configFile(fileId: "global-maven-settings", targetLocation: "settings.xml")]){
                            // 执行 Maven 命令构建项目
                            sh "mvn -T 1C clean ${MAVEN_BUILD_OPTION} -Dmaven.test.skip=true --settings settings.xml"
                        }
                    }
                }
                stage('读取pom.xml参数阶段'){
                    // 读取 Pom.xml 参数
                    pom = readMavenPom file: './pom.xml'
                    // 设置 appName 和 appVersion 两个全局参数
                    appName = "${pom.artifactId}"
                    appVersion = "${pom.version}"
                }
                stage('Docker阶段'){
                    container('docker') {
                        // 创建 Dockerfile 文件，但只能在方法块内使用
                        configFileProvider([configFile(fileId: "${params.DOCKER_DOCKERFILE_ID}", targetLocation: "Dockerfile")]){
                            // 设置 Docker 镜像名称
                            dockerImageName = "${params.DOCKER_HUB_URL}/${params.DOCKER_HUB_GROUP}/${appName}:${appVersion}"
                            // 判断 DOCKER_HUB_GROUP 是否为空，有些仓库是不设置仓库组的
                            if ("${params.DOCKER_HUB_GROUP}" == '') {
                                dockerImageName = "${params.DOCKER_HUB_URL}/${appName}:${appVersion}"
                            }
                            // 提供 Docker 环境，使用 Docker 工具来进行 Docker 镜像构建与推送
                            docker.withRegistry("http://${params.DOCKER_HUB_URL}", "${params.DOCKER_HUB_CREADENTIAL}") {
                                def customImage = docker.build("${dockerImageName}")
                                customImage.push()
                            }
                        }
                    }
                }
            }
        }
    }

**变量介绍：**

- **DOCKER_DOCKERFILE_ID：** Dockerfile 文件的 ID。
- **DOCKER_HUB_URL：** Docker 仓库 URL 地址。
- **DOCKER_HUB_GROUP：** Docker 仓库项目组名。
- **DOCKER_HUB_CREADENTIAL：** Docker 仓库认证凭据。
- **appName：** 从 pom.xml 中读取的应用名称。
- **appVersion：** 从 pom.xml 中读取的应用版本号。

### 6、Kubernetes 模块

    timeout(time: 600, unit: 'SECONDS') {
        def label = "jnlp-agent"
        podTemplate(label: label,cloud: 'kubernetes' ){
            node (label) {
                stage('Git阶段'){
                    git changelog: true,
                        url: "${params.GIT_PROJECT_URL}"，
                        branch: "${params.GIT_BRANCH}",
                        credentialsId: "${params.GIT_CREADENTIAL}"
                }
                stage('Maven阶段'){
                    container('maven') {
                        // 创建 Maven 需要的 Settings.xml 文件
                        configFileProvider([configFile(fileId: "global-maven-settings", targetLocation: "settings.xml")]){
                            // 执行 Maven 命令构建项目
                            sh "mvn -T 1C clean ${MAVEN_BUILD_OPTION} -Dmaven.test.skip=true --settings settings.xml"
                        }
                    }
                }
                stage('读取pom.xml参数阶段'){
                    // 读取 Pom.xml 参数
                    pom = readMavenPom file: './pom.xml'
                    // 设置 appName 和 appVersion 两个全局参数
                    appName = "${pom.artifactId}"
                    appVersion = "${pom.version}"
                }
                stage('Docker阶段'){
                    container('docker') {
                        // 创建 Dockerfile 文件，但只能在方法块内使用
                        configFileProvider([configFile(fileId: "${params.DOCKER_DOCKERFILE_ID}", targetLocation: "Dockerfile")]){
                            // 设置 Docker 镜像名称
                            dockerImageName = "${params.DOCKER_HUB_URL}/${params.DOCKER_HUB_GROUP}/${appName}:${appVersion}"
                            // 判断 DOCKER_HUB_GROUP 是否为空，有些仓库是不设置仓库组的
                            if ("${params.DOCKER_HUB_GROUP}" == '') {
                                dockerImageName = "${params.DOCKER_HUB_URL}/${appName}:${appVersion}"
                            }
                            // 提供 Docker 环境，使用 Docker 工具来进行 Docker 镜像构建与推送
                            docker.withRegistry("http://${params.DOCKER_HUB_URL}", "${params.DOCKER_HUB_CREADENTIAL}") {
                                def customImage = docker.build("${dockerImageName}")
                                customImage.push()
                            }
                        }
                    }
                }
                stage('Kubernetes 阶段'){
                    container('kubectl') {
                        // 使用 Kubectl Cli 插件的方法，提供 Kubernetes 环境，在其方法块内部能够执行 kubectl 命令
                        withKubeConfig([credentialsId: "${params.KUBERNETES_CREADENTIAL}",serverUrl: "https://kubernetes.default.svc.cluster.local"]) {
                            // 使用 configFile 插件，创建 Kubernetes 部署文件 deployment.yaml
                            configFileProvider([configFile(fileId: "${params.KUBERNETES_DEPLOYMENT_ID}", targetLocation: "deployment.yaml")]){
                                // 读取 Kubernetes 部署文件
                                deploy = readFile encoding: "UTF-8", file: "deployment.yaml"
                                // 替换部署文件中的变量，并将替换后的文本赋予 deployfile 变量
                                deployfile = deploy.replaceAll("#APP_NAME","${appName}")
                                               .replaceAll("#APP_REPLICAS","${params.KUBERNETES_APP_REPLICAS}")
                                               .replaceAll("#APP_IMAGE_NAME","${dockerImageName}")
                                               .replaceAll("#APP_UUID",(new Random().nextInt(100000)).toString())
                                // 生成新的 Kubernetes 部署文件，内容为 deployfile 变量中的文本，文件名称为 "deploy.yaml"
                                writeFile encoding: 'UTF-8', file: './deploy.yaml', text: "${deployfile}"
                                // 输出新创建的部署 yaml 文件内容
                                sh "cat deploy.yaml"
                                // 执行 Kuberctl 命令进行部署操作
                                sh "kubectl apply -n ${params.KUBERNETES_NAMESPACE} -f deploy.yaml"
                            }
                        }
                    }
                }
            }
        }
    }

**变量介绍：**

- **KUBERNETES_DEPLOYMENT_ID：** Kubernetes 部署文件的 ID。
- **KUBERNETES_CREADENTIAL：** Kubernetes API 认证凭据。
- **KUBERNETES_NAMESPACE：** Kubernetes 部署应用的 Namespace。
- **KUBERNETES_APP_REPLICAS：** Kubernetes 部署应用的副本数。
- **appName：** 从 pom.xml 中读取的应用名称。
- **dockerImageName：** Docker 镜像名称。

### 7、HTTP 健康检查模块

    timeout(time: 600, unit: 'SECONDS') {
        def label = "jnlp-agent"
        podTemplate(label: label,cloud: 'kubernetes' ){
            node (label) {
                stage('Git阶段'){
                    git changelog: true,
                        url: "${params.GIT_PROJECT_URL}"，
                        branch: "${params.GIT_BRANCH}",
                        credentialsId: "${params.GIT_CREADENTIAL}"
                }
                stage('Maven阶段'){
                    container('maven') {
                        // 创建 Maven 需要的 Settings.xml 文件
                        configFileProvider([configFile(fileId: "global-maven-settings", targetLocation: "settings.xml")]){
                            // 执行 Maven 命令构建项目
                            sh "mvn -T 1C clean ${MAVEN_BUILD_OPTION} -Dmaven.test.skip=true --settings settings.xml"
                        }
                    }
                }
                stage('读取pom.xml参数阶段'){
                    // 读取 Pom.xml 参数
                    pom = readMavenPom file: './pom.xml'
                    // 设置 appName 和 appVersion 两个全局参数
                    appName = "${pom.artifactId}"
                    appVersion = "${pom.version}"
                }
                stage('Docker阶段'){
                    container('docker') {
                        // 创建 Dockerfile 文件，但只能在方法块内使用
                        configFileProvider([configFile(fileId: "${params.DOCKER_DOCKERFILE_ID}", targetLocation: "Dockerfile")]){
                            // 设置 Docker 镜像名称
                            dockerImageName = "${params.DOCKER_HUB_URL}/${params.DOCKER_HUB_GROUP}/${appName}:${appVersion}"
                            // 判断 DOCKER_HUB_GROUP 是否为空，有些仓库是不设置仓库组的
                            if ("${params.DOCKER_HUB_GROUP}" == '') {
                                dockerImageName = "${params.DOCKER_HUB_URL}/${appName}:${appVersion}"
                            }
                            // 提供 Docker 环境，使用 Docker 工具来进行 Docker 镜像构建与推送
                            docker.withRegistry("http://${params.DOCKER_HUB_URL}", "${params.DOCKER_HUB_CREADENTIAL}") {
                                def customImage = docker.build("${dockerImageName}")
                                customImage.push()
                            }
                        }
                    }
                }
                stage('Kubernetes 阶段'){
                    container('kubectl') {
                        // 使用 Kubectl Cli 插件的方法，提供 Kubernetes 环境，在其方法块内部能够执行 kubectl 命令
                        withKubeConfig([credentialsId: "${params.KUBERNETES_CREADENTIAL}",serverUrl: "https://kubernetes.default.svc.cluster.local"]) {
                            // 使用 configFile 插件，创建 Kubernetes 部署文件 deployment.yaml
                            configFileProvider([configFile(fileId: "${params.KUBERNETES_DEPLOYMENT_ID}", targetLocation: "deployment.yaml")]){
                                // 读取 Kubernetes 部署文件
                                deploy = readFile encoding: "UTF-8", file: "deployment.yaml"
                                // 替换部署文件中的变量，并将替换后的文本赋予 deployfile 变量
                                deployfile = deploy.replaceAll("#APP_NAME","${appName}")
                                               .replaceAll("#APP_REPLICAS","${params.KUBERNETES_APP_REPLICAS}")
                                               .replaceAll("#APP_IMAGE_NAME","${dockerImageName}")
                                               .replaceAll("#APP_UUID",(new Random().nextInt(100000)).toString())
                                // 生成新的 Kubernetes 部署文件，内容为 deployfile 变量中的文本，文件名称为 "deploy.yaml"
                                writeFile encoding: 'UTF-8', file: './deploy.yaml', text: "${deployfile}"
                                // 输出新创建的部署 yaml 文件内容
                                sh "cat deploy.yaml"
                                // 执行 Kuberctl 命令进行部署操作
                                sh "kubectl apply -n ${params.KUBERNETES_NAMESPACE} -f deploy.yaml"
                            }
                        }
                    }
                }
                stage('健康检查阶段'){
                    // 设置检测延迟时间 10s,10s 后再开始检测
                    sleep 10
                    // 健康检查地址
                    httpRequestUrl = "http://${appName}.${params.KUBERNETES_NAMESPACE}:${params.HTTP_REQUEST_PORT}${params.HTTP_REQUEST_URL}"
                    // 循环使用 httpRequest 请求，检测服务是否启动
                    for(n = 1; n <= "${params.HTTP_REQUEST_NUMBER}".toInteger(); n++){
                        try{
                            // 输出请求信息和请求次数
                            print "访问服务：${appName} \n" +
                                  "访问地址：${httpRequestUrl} \n" +
                                  "访问次数：${n}"
                            // 如果非第一次检测，就睡眠一段时间，等待再次执行 httpRequest 请求
                            if(n > 1){
                                sleep "${params.HTTP_REQUEST_INTERVAL}".toInteger()
                            }
                            // 使用 HttpRequest 插件的 httpRequest 方法检测对应地址
                            result = httpRequest "${httpRequestUrl}"
                            // 判断是否返回 200
                            if ("${result.status}" == "200") {
                                print "Http 请求成功，流水线结束"
                                break
                            }
                        }catch(Exception e){
                            print "监控检测失败，将在 ${params.HTTP_REQUEST_INTERVAL} 秒后将再次检测。"
                            // 判断检测次数是否为最后一次检测，如果是最后一次检测，并且还失败了，就对整个 Jenkins 任务标记为失败
                            if (n == "${params.HTTP_REQUEST_NUMBER}".toInteger()) {
                                currentBuild.result = "FAILURE"
                            }
                        }
                    }
                }
            }
        }
    }

**变量介绍：**

- **HTTP_REQUEST_PORT：** HTTP 健康检查端口。
- **HTTP_REQUEST_URL：** HTTP 健康检查 URL 地址。
- **HTTP_REQUEST_NUMBER：** HTTP 健康检查次数。
- **HTTP_REQUEST_INTERVAL：** HTTP 健康检查间隔。
- **KUBERNETES_NAMESPACE：** Kubernetes 的 Namespace。
- **appName：** 从 pom.xml 中读取的应用名称。

### 8、完整脚本

    def label = "jnlp-agent"
    timeout(time: 900, unit: 'SECONDS') {
        podTemplate(label: label,cloud: 'kubernetes' ){
            node (label) {
                stage('Git阶段'){
                    // 执行 Git 命令进行 Clone 项目
                    git changelog: true,
                        branch: "${params.GIT_BRANCH}",
                        credentialsId: "${params.GIT_CREADENTIAL}",
                        url: "${GIT_PROJECT_URL}"
                }
                stage('Maven阶段'){
                    container('maven') {
                        // 创建 Maven 需要的 Settings.xml 文件
                        configFileProvider([configFile(fileId: "global-maven-settings", targetLocation: "settings.xml")]){
                            // 执行 Maven 命令构建项目，并且设置 Maven 配置为刚刚创建的 Settings.xml 文件
                            sh "mvn -T 1C clean ${MAVEN_BUILD_OPTION} -Dmaven.test.skip=true --settings settings.xml"
                        }
                    }
                }
                stage('读取pom.xml参数阶段'){
                    // 读取 Pom.xml 参数
                    pom = readMavenPom file: './pom.xml'
                    // 设置 appName 和 appVersion 两个全局参数
                    appName = "${pom.artifactId}"
                    appVersion = "${pom.version}"
                }
                stage('Docker阶段'){
                    container('docker') {
                        // 创建 Dockerfile 文件，但只能在方法块内使用
                        configFileProvider([configFile(fileId: "${params.DOCKER_DOCKERFILE_ID}", targetLocation: "Dockerfile")]){
                            // 设置 Docker 镜像名称
                            dockerImageName = "${params.DOCKER_HUB_URL}/${params.DOCKER_HUB_GROUP}/${appName}:${appVersion}"
                            if ("${params.DOCKER_HUB_GROUP}" == '') {
                                dockerImageName = "${params.DOCKER_HUB_URL}/${appName}:${appVersion}"
                            }
                            // 提供 Docker 环境，使用 Docker 工具来进行 Docker 镜像构建与推送
                            docker.withRegistry("http://${params.DOCKER_HUB_URL}", "${params.DOCKER_HUB_CREADENTIAL}") {
                                def customImage = docker.build("${dockerImageName}")
                                customImage.push()
                            }
                        }
                    }
                }
                stage('Kubernetes 阶段'){
                    // kubectl 镜像
                    container('kubectl') {
                        // 使用 Kubectl Cli 插件的方法，提供 Kubernetes 环境，在其方法块内部能够执行 kubectl 命令
                        withKubeConfig([credentialsId: "${params.KUBERNETES_CREADENTIAL}",serverUrl: "https://kubernetes.default.svc.cluster.local"]) {
                            // 使用 configFile 插件，创建 Kubernetes 部署文件 deployment.yaml
                            configFileProvider([configFile(fileId: "${params.KUBERNETES_DEPLOYMENT_ID}", targetLocation: "deployment.yaml")]){
                                // 读取 Kubernetes 部署文件
                                deploy = readFile encoding: "UTF-8", file: "deployment.yaml"
                                // 替换部署文件中的变量，并将替换后的文本赋予 deployfile 变量
                                deployfile = deploy.replaceAll("#APP_NAME","${appName}")
                                               .replaceAll("#APP_REPLICAS","${params.KUBERNETES_APP_REPLICAS}")
                                               .replaceAll("#APP_IMAGE_NAME","${dockerImageName}")
                                               .replaceAll("#APP_UUID",(new Random().nextInt(100000)).toString())
                                // 生成新的 Kubernetes 部署文件，内容为 deployfile 变量中的文本，文件名称为 "deploy.yaml"
                                writeFile encoding: 'UTF-8', file: './deploy.yaml', text: "${deployfile}"
                                // 输出新创建的部署 yaml 文件内容
                                sh "cat deploy.yaml"
                                // 执行 Kuberctl 命令进行部署操作
                                sh "kubectl apply -n ${params.KUBERNETES_NAMESPACE} -f deploy.yaml"
                            }
                        }
                    }
                }
                stage('应用启动检查'){
                    // 设置检测延迟时间 10s,10s 后再开始检测
                    sleep 10
                    // 健康检查地址
                    httpRequestUrl = "http://${appName}.${params.KUBERNETES_NAMESPACE}:${params.HTTP_REQUEST_PORT}${params.HTTP_REQUEST_URL}"
                    // 循环使用 httpRequest 请求，检测服务是否启动
                    for(n = 1; n <= "${params.HTTP_REQUEST_NUMBER}".toInteger(); n++){
                        try{
                            // 输出请求信息和请求次数
                            print "访问服务：${appName} \n" +
                                  "访问地址：${httpRequestUrl} \n" +
                                  "访问次数：${n}"
                            // 如果非第一次检测，就睡眠一段时间，等待再次执行 httpRequest 请求
                            if(n > 1){
                                sleep "${params.HTTP_REQUEST_INTERVAL}".toInteger()
                            }
                            // 使用 HttpRequest 插件的 httpRequest 方法检测对应地址
                            result = httpRequest "${httpRequestUrl}"
                            // 判断是否返回 200
                            if ("${result.status}" == "200") {
                                print "Http 请求成功，流水线结束"
                                break
                            }
                        }catch(Exception e){
                            print "监控检测失败，将在 ${params.HTTP_REQUEST_INTERVAL} 秒后将再次检测。"
                            // 判断检测次数是否为最后一次检测，如果是最后一次检测，并且还失败了，就对整个 Jenkins 任务标记为失败
                            if (n == "${params.HTTP_REQUEST_NUMBER}".toInteger()) {
                                currentBuild.result = "FAILURE"
                            }
                        }
                    }
                }
            }
        }
    }

将该流水线代码，配置到之前的模板 Job 的流水线脚本中，方便后续项目以此项目为模板。

## 九、创建任务从模板任务复制配置

这里我们新创建一个测试的示例项目 Job，命名为 **new-test**，除了新建命名外，其它配置直接复制上面的模板 Job，然后修改配置中的默认的 Git 地址、Git 凭据、Kubernetes Namespace 等变量参数值。

### 1、创建新的 Job 并复制模板项目配置

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-test-job-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-test-job-1.png)

### 2、修改新建 Job 的部分配置项

**修改 Git 项目地址**

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-test-job-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-test-job-2.png)

**修改 Git 凭据**

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-test-job-3.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-test-job-3.png)

**修改 Kubernetes Namespace**

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-test-job-4.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-test-job-4.png)

一般情况下就需要修改上面这些参数，其它默认即可，不过特殊项目特殊处理，例如，健康检查端口非 8081 就需要单独改端口变量配置，检查地址非 /actuator/health 就需要检查健康检查地址，Docker hub 凭据非默认设置就需要配置新的凭据等等，这些都需要根据项目的不同单独修改的。

## 十、执行 pipeline 任务进行测试

执行上面创建的 Pipeline Job，点击 Build with Parameters 查看配置的参数是否有误，没有错误就开始执行任务。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-check-2.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-check-2.png) [![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-check-1.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-check-1.png)

查看整个执行的各个节点，是否哪部都能够成功构建，如果出现错误，需要查看控制台输出的日志查找错误点，然后对脚本进行修改。

[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-check-3.png)](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/jenkins-kubernetes-ci&cd-check-3.png)

