# experiment_prometheus_cascade_multicluster

## Diagram
```
c1/prometehus ---|---> influxdb
c2/prometehus ---|---> influxdb <-- prometheus <-- grafana
c3/prometheus ---|---> influxdb
```

## Start the experiment
```sh
docker swarm init # If swarm not yet initialized
docker stack deploy -c docker-compose.yml prom
```

Access the components:
- Grafana: http://localhost:3000 (admin:admin)
- Prometheus: http://localhost:9090
- C1 Prometheus: http://localhost:9001
- C2 Prometheus: http://localhost:9002
- C3 Prometheus: http://localhost:9003

## Prometheus external labels

To make this construct work, we share the same external label across all prometheus instances:
```
  external_labels:
    monitor: 'meta
```

The "lower" prometheus instances may/should have additional labels, that are then visible/queryable in the "upper" prometheus instance(s):
```
  external_labels:
    monitor: 'meta'
    cluster: 'c3'
```

## Stop the experiment
```sh
docker stack rm prom
docker volume prune
docker swarm leave --force # If swarm is not needed anymore
```

## Outcome
- prometheus instances have to share the same external labels. the "lower" instances may have additional labels, that appear on the "upper" instance
- the inner prometheus may not have a remote_read, at least sometimes this led to half empty Inner-dashboard in Grafana

## Some useful commands
```sh
docker stack ls
docker stack ps prom
docker stack rm prom
docker stack services prom
docker container prune
docker image prune
docker network prune
docker volume prune
docker volume ls
docker service ls
docker service logs -f prom_prometheus-inner
docker ps
docker exec -it INFLUX_CONTAINERID influx
curl -X POST http://localhost:9090/-/reload
```

## TODO
- get prom config from external git repo
- add alertmanager
- test influence of external_labels for read/write

## Bugs found
- not all labels visible in http://localhost:9091/api/v1/label/__name__/values, but queryable
- incoming POST requests without user auth leading to 404s:
  docker service logs -f prom_influxdb
  prom_influxdb.1.zj2lyknl5z0s@linuxkit-025000000001    | [httpd] 10.255.0.2 - - [08/Feb/2018:18:36:04 +0000] "POST /api/v1/prom/write?db=prometheusremote HTTP/1.1" 404 53 "-" "Go-http-client/1.1" eb745727-0cfe-11e8-8e13-000000000000 289
  prom_influxdb.1.zj2lyknl5z0s@linuxkit-025000000001    | [httpd] 10.0.1.6 - user [08/Feb/2018:18:36:05 +0000] "POST /api/v1/prom/write?db=prometheus&p=%5BREDACTED%5D&u=user HTTP/1.1" 204 0 "-" "Go-http-client/1.1" ec26a2bc-0cfe-11e8-8e14-000000000000 3357
  > try to identify source ips, but prometheus-inner is the only instance configured with "/api/v1/prom/write"
  > unknown whether problem has its source in docker, influxdb or prometheus

