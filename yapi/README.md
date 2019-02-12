# YApi

YApi 是高效、易用、功能强大的 api 管理平台，旨在为开发、产品、测试人员提供更优雅的接口管理服务。可以帮助开发者轻松创建、发布、维护 API，
YApi 还为用户提供了优秀的交互体验，开发人员只需利用平台提供的接口数据写入工具以及简单的点击操作就可以实现接口的管理



### 使用 Docker 构建 Yapi

1、创建 MongoDB 数据卷

```
docker volume create mongo_data_yapi
```
2、启动 MongoDB

```
docker run -d --name mongo-yapi -v mongo_data_yapi:/data/db mongo
```

3、获取 Yapi 镜像

```
docker pull zhanghaichang/yapi:1.5.0
```

4、初始化 Yapi 数据库索引及管理员账号

```
docker run -it --rm \
  --link mongo-yapi:mongo \
  --entrypoint npm \
  --workdir /api/vendors \
  zhanghaichang/yapi:1.5.0 \
  run install-server
```

5、启动 Yapi 服务

```
docker run -d \
  --name yapi \
  --link mongo-yapi:mongo \
  --workdir /api/vendors \
  -p 3000:3000 \
  zhanghaichang/yapi:1.5.0 \
  server/app.js

```

6、使用 Yapi

访问 http://localhost:3000 登录账号 admin@admin.com，密码 ymfe.org

### 本地构建镜像

以下所有文件均放在同一目录下

```
./build <Version>

```
示例： ./build 1.4.3

 
