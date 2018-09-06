# experiment_prometheus_cascade

## Objective

Monitor for example an Openshift-Cluster from inside using Prometheus (with a low retention time), but push all metrics to an external InfluxDB using `remote_write`. This InfluxDB is then queried using `remote_read` from an outer Prometheus. This outer Prometheus is the datasource for some Grafana dashboards.

In an later extension we want to try federation instead of `remote_write`.

## The obvious words of warning by Brian Brazil

In general you should only be planning on pulling aggregated or other low-cardinality metrics from remote storage, as you would for federation.

Remote storage is for pre-aggregated data used for occasional long-term graphs, not as your primary storage.

## Diagram
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
- prometheus instances have to share the same external labels. the "lower" instance may have additional labels, that appear on the "upper" instance
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
- get inner prometheus config from external git repo
- add alertmanager
- test federation https://banzaicloud.com/blog/prometheus-federation/

## Bugs found
- not all labels visible in http://localhost:9091/api/v1/label/__name__/values, but queryable
