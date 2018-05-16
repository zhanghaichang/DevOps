
# K8S


### 污点
kubectl taint nodes --all node-role.kubernetes.io/master-


kubectl exec `kubectl get pods -l run=my-nginx  -o=name|cut -d "/" -f2` cat /tmp/log_level
