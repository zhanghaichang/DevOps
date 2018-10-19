## Consul docker

docker pull consul

## Running Consul for Development

```
$ docker run -d -e CONSUL_BIND_INTERFACE=eth0 consul agent -dev -join=172.17.0.2
... server 2 starts
$ docker run -d -e CONSUL_BIND_INTERFACE=eth0 consul agent -dev -join=172.17.0.2
... server 3 starts
```

#### 查看成员数量
```
$ docker exec -t dev-consul consul members
```

## Running Consul Agent in Client Mode

```
docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul agent -bind=<external ip> -retry-join=<root agent ip>
```


## Running Consul Agent in Server Mode

```
$ docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' consul agent -server -bind=<external ip> -retry-join=<root agent ip> -bootstrap-expect=<number of server agents>

```

## Exposing Consul's DNS Server on Port 53

```
$ docker run -d --net=host -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' consul -dns-port=53 -recursor=8.8.8.8
```
