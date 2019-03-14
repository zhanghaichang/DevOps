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

```
/etc/vsftpd/vsftpd.conf：vsftpd 的核心配置文件

/etc/vsftpd/ftpusers：用于指定哪些用户不能访问FTP 服务器。  黑名单

/etc/vsftpd/user_list：指定允许使用vsftpd 的用户列表文件。  白名单

/etc/vsftpd/chroot_list：指定允许使用vsftpd 的用户列表文件。  控制名单下的目录能不能离开ftp根目录
```
### 重启vsftpd

```
sudo service vsftpd restart
```
vsftpd.conf具体配置如下：

```
anonymous_enable=NO  #允许匿名用户访问为了安全选择关闭
local_enable=YES   # 允许本地用户登录
write_enable=YES   # 是否允许写入
local_umask=022  # 本地用户上传文件的umask
dirmessage_enable=YES #为YES则进入目录时显示此目录下由message_file选项指定的文本文件(,默认为.message)的内容
xferlog_enable=YES #开启日志

xferlog_std_format=YES #标准格式
connect_from_port_20=YES
xferlog_file=/var/log/xferlog   #ftp日志目录

idle_session_timeout=6000 #设置客户端连接时间

data_connection_timeout=1200 #设置数据连接时间 针对上传，下载
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list #设置为YES则下面的控制有效
chroot_list_enable=YES #若为NO,则记录在chroot_list_file所指定的文件(默认是/etc/vsftpd.chroot_list)中的用户将被chroot在登录后所在目录中,无法离开.如果为YES,则所记录的用户将不被chroot.这里YES.
chroot_local_user=YES
userlist_deny=NO #若设置为YES则记录在userlist_file选项指定文件(默认是/etc/vsftpd.user_list)中的用户将无法login,并且将检察下面的userlist_deny选项
userlist_enable=YES #若为NO,则仅接受记录在userlist_file选项指定文件(默认是/etc/vsftpd.user_list)中的用户的login请求.若为YES则不接受这些用户的请求.
userlist_file=/etc/vsftpd/user_list #白名单
chroot_list_enable=YES
local_root=/var/ftp/pub #根目录
listen=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
```
