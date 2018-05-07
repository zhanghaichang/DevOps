# EFK install

setenforce 0

cat /etc/selinux/config  
永久关闭,可以修改配置文件/etc/selinux/config,将其中SELINUX设置为disabled，如下，
SELINUX=disabled  
