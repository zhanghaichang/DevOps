## Ftp


### 卸载vsftpd

```
sudo yum remove vsftpd
```

### 安装vsftpd

```
sudo yum -y install vsftpd
```

### 创建一个文件夹用来当作ftp得仓库

```
cd /
sudo mkdir ftpfile
```

### 创建一个用户,仅对文件夹有上传权限,又没有登陆权限

```
sudo useradd ftpuser -d /ftpfile/ -s /sbin/nologin
//赋值权限
sudo chown -R ftpuser.ftpuser /ftpfile/
//重置改用户的密码
sudo passwd ftpuser
```

### 配置ftp服务器

```
//配置ftp服务器器指向文件夹,以及配置用户
sudo vim /etc/vsftpd/vsftpd.conf
//放开  连接成功时的欢迎信息
ftpd_banner=Welcome to blah FTP service.
//新增仓库地址
local_root=/ftpfile
anon_root=/ftpfile
//新增行 设置使用时间
use_localtime=yes
//新增行 设置被动传输接口的范围
pasv_min_port=61000
pasv_max_port=62000
//修改行 匿名访问为NO
anonymous_enable=NO
//放开 
chroot_list_enable=YES
//放开
chroot_list_file=/etc/vsftpd/chroot_list
```

### 创建配置用户的chroot_list文件

```
cd /etc/vsftpd/
sudo vim chroot_list
//增加内容  上面配置的用户的用户名
ftpuser
```

### 重启vsftpd

```
sudo service vsftpd restart
```
