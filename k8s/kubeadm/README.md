# Install kubeadm kubernetes





```
kubeadm init \
  --kubernetes-version=v1.10.2 \
  --pod-network-cidr=10.244.0.0/16 \
  --apiserver-advertise-address=35.194.184.155
```
