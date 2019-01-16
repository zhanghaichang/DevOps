# Nodejs

## Windows篇

下载对应你系统的Node.js版本: [https://nodejs.org/en/download/](https://nodejs.org/en/download/)

## 环境配置

环境配置主要配置的是npm安装的全局模块所在的路径，以及缓存cache的路径，之所以要配置，
是因为以后在执行类似：npm install express [-g] （后面的可选参数-g，g代表global全局安装的意思）的安装语句时，
会将安装的模块安装到【C:\Users\用户名\AppData\Roaming\npm】路径中，占C盘空间

我希望将全模块所在路径和缓存路径放在我node.js安装的文件夹中，则在我安装的文件夹【D:\Develop\nodejs】
下创建两个文件夹【node_global】及【node_cache】

打开cmd命令窗口，输入
```
npm config set prefix "D:\Develop\nodejs\node_global"
npm config set cache "D:\Develop\nodejs\node_cache"

```
接下来设置环境变量，关闭cmd窗口，“我的电脑”-右键-“属性”-“高级系统设置”-“高级”-“环境变量”
进入环境变量对话框，在【系统变量】下新建【NODE_PATH】，输入【D:\Develop\nodejs\node_global\node_modules】，
将【用户变量】下的【Path】修改为【D:\Develop\nodejs\node_global】

## 配置国内镜像

指定从哪个镜像服务器获取资源，可以使用阿里巴巴在国内的镜像服务器，命令如下：
```
npm install -gd express --registry=http://registry.npm.taobao.org

```
只需要使用–registry参数指定镜像服务器地址，为了避免每次安装都需要--registry参数，可以使用如下命令进行永久设置：
```
npm config set registry http://registry.npm.taobao.org
```

## 测试

配置完后，安装个module测试下，我们就安装最常用的express模块，打开cmd窗口，
输入如下命令进行模块的全局安装
```
npm install express -g    
# -g是全局安装的意思
```
