apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: image-clean
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: image-clean
            image: docker:latest
            args:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
            volumeMounts:
            - name: docker-vol
              mountPath: /var/run/docker.sock
          volumes:
          - hostPath:
              path: /var/run/docker.sock
              type: ""
            name: docker-vol
          restartPolicy: OnFailure
