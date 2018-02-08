# experiment_prometheus_cascade

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

## Stop the experiment
```sh
docker swarm rm prom
./prune_data.sh
docker swarm leave --force # If swarm is not needed anymore
```

## Some useful commands
```sh
docker stack ls
docker stack ps prom
docker stack rm prom
docker stack services prom
docker service ls
docker service logs -f prom_prometheus-inner
docker ps
docker exec -it INFLUX_CONTAINERID influx
```

## TODO
- get prom config from external git repo
- add alertmanager

## Bugs found
- not all labels visible in http://localhost:9091/api/v1/label/__name__/values, but queryable

