sudo timedatectl set-ntp false

sudo timedatectl set-time '2019-01-01 00:00:00'


docker stop 4cbdffe60664


docker create --volumes-from 4cbdffe60664 \
--name rancher-data rancher/rancher:v2.1.0


docker create --volumes-from 4cbdffe60664 \
--name rancher-data-snapshot-stable rancher/rancher:v2.1.0



docker run -d --volumes-from rancher-data --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:stable




docker run -d --volumes-from rancher-data-snapshot-stable --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:v2.1.0



b38c62f16f92


docker start 4cbdffe60664


docker run  \
--volumes-from rancher-data-snapshot-stable \
-v $PWD:/backup \
alpine \
tar zcvf /backup/rancher-data-backup-v2.1.0-20191112.tar.gz /var/lib/rancher


sudo timedatectl set-ntp true


证书备份


cp -rp /etc/kubernetes /etc/kubernetes.bak

移除过期证书

rm -rf /etc/kubernetes/ssl/*


查看证书有效日期

openssl x509 -in /etc/kubernetes/ssl/kube-apiserver.pem  -noout -dates




