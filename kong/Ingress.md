
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: echo
  annotations:
    kubernetes.io/ingress.class: "kong"
spec:
  rules:
  - http:
      paths:
      - path: /echo
        backend:
          serviceName: echo
          servicePort: 8080
```
