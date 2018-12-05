#!/bin/bash
if [ -z "${MAVEN_HOME}" ]; then
#得到时间
TIME_FLAG=`date +%Y%m%d_%H%M%S`
#备份配置文件
cp /etc/profile /etc/profile.bak_$TIME_FLAG
echo "Begin to install maven,Please waiting..."
#解压maven
wget https://www-eu.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar -xzvf apache-maven-3.5.4-bin.tar.gz
#拷贝maven到安装目录
cp -rf apache-maven-3.5.4 /usr/local/
echo "######################################"
echo "Begin to config environment variables,please waiting..."
echo "######################################"
#修改maven的环境变量，直接写入配置文件
echo "MAVEN_HOME=/usr/local/apache-maven-3.5.4" >>/etc/profile
echo "PATH=\$PATH:\$MAVEN_HOME/bin" >>/etc/profile
#运行后直接生效
source /etc/profile
echo "环境变量设置成功"
else
echo "本机已安装maven无需再次安装"
fi
