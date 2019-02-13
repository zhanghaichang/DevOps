# 漏洞补丁

Server Version: 17.03.2-ce

[下载补丁](https://github.com/rancher/runc-cve/releases)

```shell
# Figure out where your docker-runc is, typically in /usr/bin/docker-runc
which docker-runc

# Backup
mv /usr/bin/docker-runc /usr/bin/docker-runc.orig.$(date -Iseconds)

# Copy file
cp runc-v17.06.2-amd64 /usr/bin/docker-runc

# Ensure it's executable
chmod +x /usr/bin/docker-runc

# Test it works
docker-runc -v
docker run -it --rm ubuntu echo OK

```
