### Creating a Cron Job


```shell
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```


```
$ kubectl create -f ./cronjob.yaml
cronjob "hello" created
Alternatively, you can use kubectl run to create a cron job without writing a full config:
```
```
$ kubectl run hello --schedule="*/1 * * * *" --restart=OnFailure --image=busybox -- /bin/sh -c "date; echo Hello from the Kubernetes cluster"
cronjob "hello" created
After creating the cron job, get its status using this command:
```
```
$ kubectl get cronjob hello
NAME      SCHEDULE      SUSPEND   ACTIVE    LAST-SCHEDULE
hello     */1 * * * *   False     0         <none>
As you can see from the results of the command, the cron job has not scheduled or run any jobs yet. Watch for the job to be created in around one minute:
```
```
$ kubectl get jobs --watch
NAME               DESIRED   SUCCESSFUL   AGE
hello-4111706356   1         1         2s
Now you’ve seen one running job scheduled by the “hello” cron job. You can stop watching the job and view the cron job again to see that it scheduled the job:
```
```
$ kubectl get cronjob hello
NAME      SCHEDULE      SUSPEND   ACTIVE    LAST-SCHEDULE
hello     */1 * * * *   False     0         Mon, 29 Aug 2016 14:34:00 -0700
You should see that the cron job “hello” successfully scheduled a job at the time specified in LAST-SCHEDULE. There are currently 0 active jobs, meaning that the job has completed or failed.

Now, find the pods that the last scheduled job created and view the standard output of one of the pods. Note that the job name and pod name are different.

# Replace "hello-4111706356" with the job name in your system
$ pods=$(kubectl get pods --selector=job-name=hello-4111706356 --output=jsonpath={.items..metadata.name})
```
```
$ echo $pods
hello-4111706356-o9qcm
```

```
$ kubectl logs $pods

Mon Aug 29 21:34:09 UTC 2016
Hello from the Kubernetes cluster
```

### Deleting a Cron Job
When you don’t need a cron job any more, delete it with kubectl delete cronjob:
```
$ kubectl delete cronjob hello
cronjob "hello" deleted
Deleting the cron job removes all the jobs and pods it created and stops it from creating additional jobs. You can read more about removing jobs in garbage collection.
```
