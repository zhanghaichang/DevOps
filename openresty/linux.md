# Linux(CentOS 7)下环境搭建

你可以在你的 CentOS 系统中添加 openresty 仓库，这样就可以便于未来安装或更新我们的软件包（通过 yum update 命令）。

运行下面的命令就可以添加openresty 的仓库：

```shell
sudo yum install yum-utils
sudo yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo
```

然后就可以像下面这样安装软件包，比如 openresty：

```shell
sudo yum install openresty
```
如果你想安装命令行工具 resty，那么可以像下面这样安装 openresty-resty 包：

```shell
sudo yum install openresty-resty
```

命令行工具 opm 在 openresty-opm 包里，而 restydoc 工具在 openresty-doc 包里头。列出所有 openresty 仓库里头的软件包：

```
sudo yum --disablerepo="*" --enablerepo="openresty" list available
```

添加lua的脚本目录

```
cd /usr/local/openresty/lualib/
mkdir testcode
cd testcode
```

创建测试lua脚本
```
cd /usr/local/openresty/lualib/testcode
vim testlua.lua
```
添加以下脚本内容

```
--用于接收前端数据的对象
local args=nil
--获取前端的请求方式 并获取传递的参数   
local request_method = ngx.var.request_method
--判断是get请求还是post请求并分别拿出相应的数据
if"GET" == request_method then
        args = ngx.req.get_uri_args()
elseif "POST" == request_method then
        ngx.req.read_body()
        args = ngx.req.get_post_args()
        --兼容请求使用post请求，但是传参以get方式传造成的无法获取到数据的bug
        if (args == nil or args.data == null) then
                args = ngx.req.get_uri_args()
        end
end

--获取前端传递的name值
local name = args.name
--响应前端
ngx.say("linux hello:"..name)

```

配置ngnix关联lua文件
cd /usr/local/openresty/nginx/conf/
vi nginx.conf
在80的server中添加以下配置信息

```
        location /luatest
        {       
                default_type text/html;
                #这里的lua文件的路径为绝对路径，请根据自己安装的实际路径填写
                #记得斜杠是/这个。
                content_by_lua_file /usr/local/openresty/lualib/testcode/testlua.lua;
        } 

```
启动nginx服务

```
cd /usr/local/openresty/nginx
sbin/nginx
```

测试nginx是否正常
打开浏览器，输入linux的ip地址,如:http://192.168.1.130/ 显示如下效果，说明nginx已经正常启动


测试OpenResty是否正常
打开浏览器,输入:http://192.168.1.130/luatest?name=openresty 显示如下效果，说明OpenResty正常
