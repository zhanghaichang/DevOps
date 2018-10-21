## ansible

## 安装 Ansible

```
shell >  yum -y install ansible

```
## 二、配置 Ansible


```
shell > ls /etc/ansible   

ansible.cfg hosts roles

ansible.cfg 是 Ansible 工具的配置文件；
hosts 用来配置被管理的机器；
roles 是一个目录，playbook 将使用它

```

**hosts 文件添加被管理机**

```
 vim /etc/ansible/hosts 
[Client]
192.168.12.129

```
## 三、测试 Ansible

```
shell > ansible Client -m ping    

下面是返回结果
192.168.12.129 | SUCCESS => {
"changed": false, 
"ping": "pong"
}

# 操作 Client 组 ( all 为操作 hosts 文件中所有主机 )，-m 指定执行 ping 模块，
# -i          指定 hosts 文件位置
# -u username 指定 SSH 连接的用户名
# -k          指定远程用户密码
# -f          指定并发数
# -s          如需要 root 权限执行时使用 ( 连接用户不是 root 时 )
# -K          -s 时，-K 输入 root 密码
```

## 四、附加

1、/etc/ansible/hosts 文件

## Ansible 定义主机、组规则的配置文件

```
shell > vim /etc/ansible/hosts

www.abc.com     # 定义域名

192.168.1.100   # 定义 IP

192.168.1.150:37268   # 指定端口号

[WebServer]           # 定义分组

192.168.1.10
192.168.1.20
192.168.1.30

[DBServer]            # 定义多个分组

192.168.1.50
192.168.1.60

Monitor ansible_ssh_port=12378 ansible_ssh_host=192.168.1.200   # 定义别名

# ansible_ssh_host 连接目标主机的地址

# ansible_ssh_port 连接目标主机的端口，默认 22 时无需指定

# ansible_ssh_user 连接目标主机默认用户

# ansible_ssh_pass 连接目标主机默认用户密码

# ansible_ssh_connection 目标主机连接类型，可以是 local 、ssh 或 paramiko

# ansible_ssh_private_key_file 连接目标主机的 ssh 私钥

# ansible_*_interpreter 指定采用非 Python 的其他脚本语言，如 Ruby 、Perl 或其他类似 ansible_python_interpreter 解释器

[webservers]         # 主机名支持正则描述

www[01:50].example.com

[dbservers]

db-[a:f].example.com
```

[更多](https://www.cnblogs.com/wangxiaoqiangs/p/5685239.html)
