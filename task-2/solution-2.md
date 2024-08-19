Creating a new deployment in Minikube using a configuration from nginx.yaml
```kubectl apply -f nginx.yaml```


1. #### Checking status of deployments, services, and pods
```$ kubectl get deployments```
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
sretest   0/1     1            0           39s

```$ kubectl get services```
NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes        ClusterIP   10.96.0.1       <none>        443/TCP        2m27s
sretest-service   NodePort    10.99.109.129   <none>        80:31756/TCP   67s


```$ kubectl get pods```
NAME                      READY   STATUS    RESTARTS   AGE
sretest-f6cd856db-vg2g5   0/1     Pending   0          93s

Status is pending

2. #### Checking logs

```kubectl describe pods```

....
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  5m6s  default-scheduler  0/1 nodes are available: 1 node(s) didn't match Pod's node affinity/selector. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling.

Result:  1 node(s) didn't match Pod's node affinity/selector.

3. #### Locating labels in the file

```cat nginx.yaml```

....
  spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/application
                operator: In
                values:
                - "sretest"
....
spec:
  selector:
    app: sretest-service
  type: NodePort
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

There are different selectors (labels) for such objects as Dedployment and Service : sretest and sretest-service.
Besides, the pod can be run only on those nodes that have the label node-role.kubernetes.io/application=sretest


5. #### Checking labels on the node

```$ kubectl get node minikube --show-labels | grep "node-role.kubernetes.io/application=sretest"```

no output. The lable node-role.kubernetes.io/application=sretest is missing 

6. #### Creating the label on the node and fixing the label in Service
```$ kubectl label node minikube node-role.kubernetes.io/application=sretest```
node/minikube labeled

....
kind: Service
metadata:
  name: sretest-service
spec:
  selector:
    app: sretest

7. #### Applying changes 
```$ kubectl apply -f nginx.yaml```
deployment.apps/sretest configured
service/sretest-service unchanged

```$ kubectl get pods```
NAME                      READY   STATUS              RESTARTS      AGE
sretest-f6cd856db-vg2g5   0/1     RunContainerError   3 (13s ago)   38m

The container did not start.

8. Returning to logs

```kubectl describe pods```

 Error: failed to start container "sretest": Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error setting cgroup config for procHooks process: failed to write "300000": write /sys/fs/cgroup/cpu/kubepods/burstable/pod02b4c6b3-885a-4cde-86c9-137280e8caf4/sretest/cpu.cfs_quota_us: invalid argument: unknown
 Warning  BackOff           8s (x5 over 68s)     kubelet            Back-off restarting failed container sretest in pod sretest-f6cd856db-vg2g5_default(02b4c6b3-885a-4cde-86c9-137280e8caf4)

Looks like the container cannot be created due to issues with CPU on the node.

9. #### Cheking CPU on the node and comparing with nginx.yaml

```minikube ssh```

```cat /proc/cgroups | grep cpu```
cpuset  1       37      1
cpu     2       52      1
cpuacct 3       37      1

```cat nginx.yaml```
...... 
resources:
          limits:
            cpu: 3
            memory: 128Mi
          requests:
            cpu: 2
            memory: 128Mi

CPU of the node (2 CPU) does not meet settings from nginx.yaml (3 CPU)

10. #### Decreasing CPU in nginx.yaml and applying changes

....
 resources:
          limits:
            cpu: 2 
            memory: 128Mi
          requests:
            cpu: 1
            memory: 128Mi

```$ kubectl apply -f nginx.yaml```
deployment.apps/sretest configured
service/sretest-service configured


11. #### Checking pods
```$ kubectl get pods```
NAME                       READY   STATUS    RESTARTS   AGE
sretest-f6cd856db-vg2g5   1/1     Running   0          19m

The container started

12. #### Checking nginx in the browser

```$ minikube ip```
192.168.49.2

```$ kubectl get services```
NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
kubernetes        ClusterIP   10.96.0.1      <none>        443/TCP        90m
sretest-service   NodePort    10.110.45.37   <none>        80:31278/TCP   86m

http:192.168.49.2:31278 - the site can't be reached.

13. #### Pinging the node from outside and inside the node.

```$ ping 192.168.49.2```

Pinging 192.168.49.2 with 32 bytes of data:
Request timed out.

```$ minikube ssh```

```docker@minikube:~$ ping 192.168.49.2```
ping 192.168.49.2
PING 192.168.49.2 (192.168.49.2) 56(84) bytes of data.
64 bytes from 192.168.49.2: icmp_seq=1 ttl=64 time=0.374 ms

The node network is not accessible from outside. 

14. #### Fetching the minikube IP and a service’s NodePort to create a tunnel

```$ minikube service sretest-service --url```
http://127.0.0.1:52957
! Because you are using a Docker driver on windows, the terminal needs to be open to run it.

15. #### Running http://127.0.0.1:52957

Welcome to nginx!
If you see this page, the nginx web server is successfully installed and working. Further configuration is required.




