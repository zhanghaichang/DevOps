# Docker nginx 安装

```shell
docker run \
    --name nginx \
    -v /data/k8s/nginx/conf.d/nginx.conf:/etc/nginx/ \
    -p 31026:80 \
    -d \
    nginx 
```
