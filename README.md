# experiment_prometheus_cascade

## Diagaram
```
node-exporter <-- prometheus-inner --> influxdb <-- prometheus-outer <-- grafana
(     inner-net         )(                     outer-net                       )
```

## Start the experiment
```sh
docker swarm init # If swarm not yet initialized
docker stack deploy -c docker-compose.yml prom
```

Access the components:
- Grafana: http://localhost:3000 (admin:admin)
- Inner Prometheus: http://localhost:9090
- Outer Prometheus: http://localhost:9091
- InfluxDB localhost:8086

Grafana show metrics from prometheus-outer on the Dasboard "Outer". As a reference
the dashboard "Inner" shows the same from prometheus-inner.

## Stop the experiment
```sh
docker stack rm prom
docker volume prune
docker swarm leave --force # If swarm is not needed anymore
```

## Outcome
- external_label have to be exactly the same, not even additional label work
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

