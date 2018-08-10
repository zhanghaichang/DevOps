

## daemon.json
> vim /etc/docker/daemon.json
{
  "insecure-registries" : ["poc-registry.quark.com","gcr.io","testharbor.quark.com"],
  "registry-mirrors": ["https://merhduid.mirror.aliyuncs.com"]
}
