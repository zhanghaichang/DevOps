# label
1.创建label

kubectl label nodes <node-name> <label-key>=<label-value>
1
2.查看labels

kubectl get nodes -Lsystem/build-node

kubectl get nodes --show-labels
