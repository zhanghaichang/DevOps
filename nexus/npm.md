## npm仓库

#### 在nexus Repositry 中可以创建三种类型的仓库，分别是group、hosted和proxy。
* group 指的是仓库组，可以包括hosted 和proxy的仓库。
* hosted 是指自己的私有仓库，可以上传私有代码到上面。
* proxy 就是代理镜像仓库。

一般情况下无论是Maven、pypi 还是npm，这3种类型的仓库都会分别建一个，然后用的时候指向group 仓库。创建的顺序是先hosted 或proxy ，最后才是group，因为group要包括hosted 和proxy



### 添加npm仓库

以下输入的Name都是根据自己需求修改

* 点击在左侧菜单`Repositories`, 然后点击`Create repository`按钮.
* 选择`npm(proxy)`, 输入 Name: npm-proxy, remote storage 填写 https://registry.npm.taobao.org 或 https://registry.npmjs.org. 用于将包情求代理到地址地址
* 再次点击`Create repository`按钮., 增加 npm(hossted) 输入 Name: npm-xueyou 用于存放自己的私有包
* 再次点击`Create repository`按钮.,增加npm(group) 输入 Name: npm-all, 下面`Member repositories`里选择之前添加的2个移动右边.


### 配置与验证npm仓库


* `$npm config set registry http://localhost:8081/repository/npm-all/` 这里的url在仓库 npm-all 右边有获取url
* 随便进入一个目录, 初始化package, `npm init -y`, `npm --loglevel info install grunt` 查看是否从自己的仓库地址拉取包
* 设置权限, Realms 菜单, 将 npm Bearer Token Realm 添加到右边
* 添加用户, 然后 `npm login –registry=http://192.168.0.102:8081/repository/npm-all/`进行登陆，需要填写账号、密码以及邮箱
* 登陆`npm login --registry=http://192.168.0.102:8081/repository/npm-all/` 输入刚才新建用户的用户和密码和邮箱


### 发布自己的包


确保要发布的模块跟目录有 package.json 文件

* 添加用户 `npm adduser -registry http://192.168.0.102:8081/repository/npm-xueyou/`
* 发布包, npm publish –registry http://192.168.0.102:8081/repository/npm-xueyou/
* 修改 `package.json 添加 "publishConfig": { "registry": "http://192.168.0.102:8081/repository/npm-xueyou/" }`, 这样直接npm publish就发布了
