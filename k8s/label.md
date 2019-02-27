# label
1.创建label

kubectl label nodes <node-name> <label-key>=<label-value>
  
2.查看labels

kubectl get nodes -Lsystem/build-node

kubectl get nodes --show-labels


## nodeselector 
```
kubectl label node k8s-node1 disktype=rancher-worker-001
```
