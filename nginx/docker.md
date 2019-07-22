# Docker nginx 安装

```shell
docker run \
    --name nginx \
    -v /data/k8s/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v /data/k8s/nginx/conf.d/:/etc/nginx/conf.d\
    -p 31026:80 \
    -d \
    nginx 
```
