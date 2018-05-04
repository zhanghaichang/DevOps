#!/bin/bash
docker run -d busybox
docker rm -f $(docker ps -qa)
rm -rf /var/etcd/
for m in $(tac /proc/mounts | awk '{print $2}' | grep /var/lib/kubelet); do
    umount $m || true
done
rm -rf /var/lib/kubelet/
for m in $(tac /proc/mounts | awk '{print $2}' | grep /var/lib/rancher); do
    umount $m || true
done
rm -rf /var/lib/rancher/
rm -rf /run/kubernetes/
rm -rf /opt/cni/bin/
docker volume rm $(docker volume ls -q)
docker ps -a
docker volume ls
