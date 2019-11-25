### 创建tracker调度容器
 
docker run -ti -d --name tracker -v /data/k8s/fastdfs/tracker_data:/fastdfs/tracker/data --net=host season/fastdfs tracker



docker cp ~/storage.conf tracker:/fdfs_conf/

docker restart  tracker

### 启动Storage 服务器

docker run -tid --name storage -v /data/k8s/fastdfs/storage_data:/fastdfs/storage/data -v /data/k8s/fastdfs/store_path:/fastdfs/store_path --net=host -e TRACKER_SERVER:218.78.83.119:22122 season/fastdfs storage

### 默认配置的ip地址不会生效需要自己重新配

docker cp storage:/fdfs_conf/storage.conf ~/ 


docker cp ~/storage.conf:/fdfs_conf/storage.conf ~/ 


vi storage.conf 进入vi界面找到tracker_server=服务器ip:22122 编辑ip地址 完成之后：wq保存退出

docker cp ~/storage.conf storage:/fdfs_conf/ 


docker restart  storage

### fastdht配置

docker run -ti -d --name fastdht --net=host manuku/fastdfs-fastdht

编辑fdht_servers.conf里面的数据,如下

docker cp fastdht:/etc/fdht/fdht_servers.conf ~/


docker cp ~/fdht_servers.conf fastdht:/etc/fdht/


docker restart fastdht


docker cp ~/fdht_servers.conf storage:/fdfs_conf/ 


docker cp storage.conf storage:/fdfs_conf/


docker restart storage


docker exec -it tracker bash

cd fdfs_conf

fdfs_upload_file storage.conf  test.txt

