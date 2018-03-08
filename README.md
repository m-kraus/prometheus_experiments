# experiment_prometheus_cascade_multicluster

## The obvious words of warning by Brian Brazil

In general you should only be planning on pulling aggregated or other low-cardinality metrics from remote storage, as you would for federation.

Remote storage is for pre-aggregated data used for occasional long-term graphs, not as your primary storage.

## Diagram
```
c1/prometheus ---|---> influxdb
c2/prometheus ---|---> influxdb <-- prometheus <-- grafana
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
    monitor: 'meta'
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
- add alertmanager (https://www.robustperception.io/high-availability-prometheus-alerting-and-notification/)
- test influence of external_labels for read/write

## Bugs found
- not all labels visible in http://localhost:9090/api/v1/label/__name__/values, but queryable
