# experiment_prometheus_influxdb_dist

## Objective

This is an experiment to find out, how we can aggregate/combine metrics from mutiple clusters monitoried by Prometheus into a single InfluxDB. The Prometheus instances in the clusters use the `remote_write` feature to get their data written into an InfluxDB for long term storage.

This data should be aggregated into a single InfluxDB instance.

Objective is to find methids, how this can be achieved.

## The obvious words of warning by Brian Brazil

In general you should only be planning on pulling aggregated or other low-cardinality metrics from remote storage, as you would for federation.

Remote storage is for pre-aggregated data used for occasional long-term graphs, not as your primary storage.

## Experiments

1. telegraf

Use `telegraf` as `remote_write` target and write data out to a central InfluxDB instance.

Outcome: `telegraf` doesn't understand the Prometheus `remote_write` format, as it is not Influx line protocol, so `telegraf` cannot be used this way.

2. influx_subscription

Use SUBSCRIPTION https://docs.influxdata.com/influxdb/v1.5/query_language/spec/#create-subscription to write ingested data immediately out to another InfluxDB instance. See also https://www.influxdata.com/blog/multiple-data-center-replication-influxdb/

Outcome: This works well, incoming/ingested data can be written to one or more InfluxDBs via udp or http. Data of muliple clusters can be collected into one single InfluxDB instance. Buffering and performance on slow networks might be a problem when writing lots of data outside. A separate InfluxDB instance means additional overhread, but can be valuable in desaster recovery scenarios. Backup can happen on a single/central instance.

3. prometheus_multiread

The outer Prometheus is configured using multiple `remote_read` configurations to query all cluster-InfluxDBs.

Outcome: This works, data from all cluster instances can be seen outside. Query performance on slow networks might be a problem. Data is kept on the source cluster.

## Start the experiment
```sh
cd EXPERIMENT
docker-compose up
```

Access the components:
- Grafana: http://localhost:3000 (admin:admin)
- Prometheus: http://localhost:9090
- C1 Prometheus: http://localhost:9001
- C2 Prometheus: http://localhost:9002
- C3 Prometheus: http://localhost:9003

The InfluxDB instances can be reaches using `docker exec -it CONTAINER bash`

## Stop the experiment
```sh
cd EXPERIMENT
docker-compose down -v
```

## Outcome
- prometheus instances have to share the same external labels. the "lower" instances may have additional labels, that appear on the "upper" instance
- the inner prometheus may not have a remote_read, at least sometimes this led to half empty Inner-dashboard in Grafana

## Some useful commands
```sh
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
