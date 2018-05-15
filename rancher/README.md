# rancher 2.0安装

vim /etc/sysconfig/docker
 remove --selinux-enabled from the OPTIONS variable

sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
