# gitlab 配置

## 仓库初始化命令

### Git 初始化配置

```shell
git config --global user.name "张海昌"
git config --global user.email "zhang.hc@topcheer.com"

```

### 创建一个仓库

```shell
git clone git@47.106.216.108:zhanghc/npm-demo.git
cd npm-demo
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master
```
### 已经存在的空项目推送gitlab

```shell
cd existing_folder
git init
git remote add origin git@47.106.216.108:zhanghc/npm-demo.git
git add .
git commit -m "Initial commit"
git push -u origin master
```


### 已经存在的项目推送gitlab
```shell
cd existing_repo
git remote add origin git@47.106.216.108:zhanghc/npm-demo.git
git push -u origin --all
git push -u origin --tags

```
