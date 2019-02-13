## shadowsocks  docker install

```shell
docker run -d -p 1984:1984 oddrationale/docker-shadowsocks --restart=always -s 0.0.0.0 -p 1984 -k $SSPASSWORD -m aes-256-cfb
```
