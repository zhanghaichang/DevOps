# Hadoop 


## 1.准备Linux环境
1.0先将虚拟机的网络模式选为NAT
	
1.1修改主机名
		vi /etc/sysconfig/network
		
		NETWORKING=yes
		HOSTNAME=itcast    ###

	1.2修改IP
		两种方式：
		第一种：通过Linux图形界面进行修改（强烈推荐）
			进入Linux图形界面 -> 右键点击右上方的两个小电脑 -> 点击Edit connections -> 选中当前网络System eth0 -> 点击edit按钮 -> 选择IPv4 -> method选择为manual -> 点击add按钮 -> 添加IP：192.168.1.101 子网掩码：255.255.255.0 网关：192.168.1.1 -> apply
	
		第二种：修改配置文件方式
			vim /etc/sysconfig/network-scripts/ifcfg-eth0
			
			DEVICE="eth0"
			BOOTPROTO="static"               ###
			HWADDR="00:0C:29:3C:BF:E7"
			IPV6INIT="yes"
			NM_CONTROLLED="yes"
			ONBOOT="yes"
			TYPE="Ethernet"
			UUID="ce22eeca-ecde-4536-8cc2-ef0dc36d4a8c"
			IPADDR="192.168.1.101"           ###
			NETMASK="255.255.255.0"          ###
			GATEWAY="192.168.1.1"            ###
			
	1.3修改主机名和IP的映射关系
		vim /etc/hosts
			
		192.168.1.101	itcast
	
	1.4关闭防火墙
		#查看防火墙状态
		service iptables status
		#关闭防火墙
		service iptables stop
		#查看防火墙开机启动状态
		chkconfig iptables --list
		#关闭防火墙开机启动
		chkconfig iptables off
	1.5 修改sudo
		su root
		vim /etc/sudoers
		给hadoop用户添加执行的权限

关闭linux服务器的图形界面：
vi /etc/inittab 


	
	1.5重启Linux
		reboot






2.安装JDK
	2.1上传alt+p 后出现sftp窗口，然后put d:\xxx\yy\ll\jdk-7u_65-i585.tar.gz
	
	2.2解压jdk
		#创建文件夹
		mkdir /home/hadoop/app
		#解压
		tar -zxvf jdk-7u55-linux-i586.tar.gz -C /home/hadoop/app
		
	2.3将java添加到环境变量中
		vim /etc/profile
		#在文件最后添加
		export JAVA_HOME=/home/hadoop/app/jdk-7u_65-i585
		export PATH=$PATH:$JAVA_HOME/bin
	
		#刷新配置
		source /etc/profile
		
3.安装hadoop2.4.1
	先上传hadoop的安装包到服务器上去/home/hadoop/
	注意：hadoop2.x的配置文件$HADOOP_HOME/etc/hadoop
	伪分布式需要修改5个配置文件
	3.1配置hadoop
	第一个：hadoop-env.sh
		vim hadoop-env.sh
		#第27行
		export JAVA_HOME=/usr/java/jdk1.7.0_65
		
	第二个：core-site.xml

		<!-- 指定HADOOP所使用的文件系统schema（URI），HDFS的老大（NameNode）的地址 -->
		<property>
			<name>fs.defaultFS</name>
			<value>hdfs://weekend-1206-01:9000</value>
		</property>
		<!-- 指定hadoop运行时产生文件的存储目录 -->
		<property>
			<name>hadoop.tmp.dir</name>
			<value>/home/hadoop/hadoop-2.4.1/tmp</value>
    </property>
		
	第三个：hdfs-site.xml   
		<!-- 指定HDFS副本的数量 -->
		<property>
			<name>dfs.replication</name>
			<value>1</value>
		</property>
		
		<property>
			<name>dfs.secondary.http.address</name>
			<value>192.168.1.152:50090</value>
		</property>

    
    
		
	第四个：mapred-site.xml (mv mapred-site.xml.template mapred-site.xml)
		mv mapred-site.xml.template mapred-site.xml
		vim mapred-site.xml
		<!-- 指定mr运行在yarn上 -->
		<property>
			<name>mapreduce.framework.name</name>
			<value>yarn</value>
		</property>
		
	第五个：yarn-site.xml
		<!-- 指定YARN的老大（ResourceManager）的地址 -->
		<property>
			<name>yarn.resourcemanager.hostname</name>
			<value>weekend-1206-01</value>
		</property>
		<!-- reducer获取数据的方式 -->
		<property>
			<name>yarn.nodemanager.aux-services</name>
			<value>mapreduce_shuffle</value>
		</property>
     	
	3.2将hadoop添加到环境变量
	
	vim /etc/proflie
		export JAVA_HOME=/usr/java/jdk1.7.0_65
		export HADOOP_HOME=/itcast/hadoop-2.4.1
		export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

	source /etc/profile
	
	3.3格式化namenode（是对namenode进行初始化）
		hdfs namenode -format (hadoop namenode -format)
		
	3.4启动hadoop
		先启动HDFS
		sbin/start-dfs.sh
		
		再启动YARN
		sbin/start-yarn.sh
		
	3.5验证是否启动成功
		使用jps命令验证
		27408 NameNode
		28218 Jps
		27643 SecondaryNameNode
		28066 NodeManager
		27803 ResourceManager
		27512 DataNode
	
		http://192.168.1.101:50070 （HDFS管理界面）
		http://192.168.1.101:8088 （MR管理界面）
		
4.配置ssh免登陆
	#生成ssh免登陆密钥
	#进入到我的home目录
	cd ~/.ssh

	ssh-keygen -t rsa （四个回车）
	执行完这个命令后，会生成两个文件id_rsa（私钥）、id_rsa.pub（公钥）
	将公钥拷贝到要免密登陆的目标机器上
	ssh-copy-id localhost
	---------------------------
	ssh免登陆：
		生成key:
		ssh-keygen
		复制从A复制到B上:
		ssh-copy-id B
		验证：
		ssh localhost/exit，ps -e|grep ssh
		ssh A  #在B中执行
	
	
## 启动Hadoop
启动Hadoop集群需要启动HDFS集群和Map/Reduce集群。

格式化一个新的分布式文件系统：
```
$ bin/hadoop namenode -format
```
在分配的NameNode上，运行下面的命令启动HDFS：
```
$ bin/start-dfs.sh
```

bin/start-dfs.sh脚本会参照NameNode上${HADOOP_CONF_DIR}/slaves文件的内容，在所有列出的slave上启动DataNode守护进程。

在分配的JobTracker上，运行下面的命令启动Map/Reduce：
```
$ bin/start-mapred.sh
```

bin/start-mapred.sh脚本会参照JobTracker上${HADOOP_CONF_DIR}/slaves文件的内容，在所有列出的slave上启动TaskTracker守护进程。

## 停止Hadoop
在分配的NameNode上，执行下面的命令停止HDFS：
```
$ bin/stop-dfs.sh
```

bin/stop-dfs.sh脚本会参照NameNode上${HADOOP_CONF_DIR}/slaves文件的内容，在所有列出的slave上停止DataNode守护进程。

在分配的JobTracker上，运行下面的命令停止Map/Reduce：
```
$ bin/stop-mapred.sh 
```
bin/stop-mapred.sh脚本会参照JobTracker上${HADOOP_CONF_DIR}/slaves文件的内容，在所有列出的slave上停止TaskTracker守护进程。

 
	
