# docker 一键在线安装

```
curl -s https://releases.rancher.com/install-docker/17.03.sh|sh

```


# rancher 2.0安装

```
vim /etc/sysconfig/docker
 remove --selinux-enabled from the OPTIONS variable

sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
```

### 稳定版本
```
sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:v2.1.0
```

### 关闭防火墙 


```
systemctl disable firewalld

systemctl stop firewalld

```

### 安装 开启 Iptables  

[iptables 安装教程](/linux/iptables.md)


## 开通端口

<table width="630">
<tbody>
<tr>
<td style="text-align: center" width="98">协议</td>
<td style="text-align: center" width="114">端口</td>
<td style="text-align: center" width="418">描述</td>
</tr>
<tr>
<td width="98">TCP</td>
<td width="114">80</td>
<td width="418">Rancher UI/API when external SSL termination is used</td>
</tr>
<tr>
<td width="98">TCP</td>
<td width="114">443</td>
<td width="418">Rancher agent, Rancher UI/API, kubectl</td>
</tr>
<tr>
<td width="98">TCP</td>
<td width="114">6443</td>
<td width="418">Kubernetes apiserver</td>
</tr>
<tr>
<td width="98">TCP</td>
<td width="114">2379</td>
<td width="418">etcd client requests</td>
</tr>
<tr>
<td width="98">TCP</td>
<td width="114">2380</td>
<td width="418">etcd peer communication</td>
</tr>
<tr>
<td width="98">UDP</td>
<td width="114">8472</td>
<td width="418">Canal/Flannel VXLAN overlay networking</td>
</tr>
<tr>
<td width="98">TCP</td>
<td width="114">10250</td>
<td width="418">kubelet</td>
</tr>
 <tr>
<td width="98">TCP/UDP</td>
<td width="114">30000-32767</td>
<td width="418">NodePort port range</td>
</tr>
</tbody>
</table>
