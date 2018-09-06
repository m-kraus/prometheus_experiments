# experiment_prometheus_outside

## Objective

This time we try to monitor an Openshift-Installation with Prometheus and Grafana from outside the cluster.
This experiment is prepared for a long-term remote_write/remote_read InfluxDB-Instance as well as a high available Alertmanager.

## Diagram
```
         API <------|------ prometheus <------- grafana
(     openshift     )(             outer               )
```

## Start the experiment

First we start an Openshift-Installation using minishift:
```sh
minishift start --memory 8GB --openshift-version v3.7.1
```

`minishift console` takes you to the Minishift Web UI. Please note down the IP-Adress, you will need it later for configuring Prometheus. For example `https://192.168.64.27:8443`

We create the needed Serviceaccount with the role `cluster-reader` and a deployment of `kube-state-metrics`.
```sh
oc login -u system:admin
oc new-project monitoring
oc new-app -p NAMESPACE=monitoring -f monitoring-template.yaml
```

To access the Openshift API from outside we need to store a token of the generated Serviceaccount:
```sh
cd prometheus
oc get sa/prometheus --template='{{range .secrets}}{{ .name }} {{end}}' | xargs -n 1 oc get secret --template='{{ if .data.token }}{{ .data.token }}{{end}}' | head -n 1 | base64 -D - > token
```

Now you have to configure Prometheus with the correct API server IP-address. Search for all occurrences of `api_server: https://xx.xx.xx.xx:xxxx` in the file `prometheus/prometheus.yml` and replace it with the IP-adress from `minishift console` (see above).

To setup the "outer" components we use Docker Swarm:
```sh
docker swarm init # If swarm not yet initialized
docker stack deploy -c docker-compose.yml prom
```

Access the components:
- Prometheus: http://localhost:9090
- (later) Grafana: http://localhost:3000 (admin:admin)

## Stop the experiment
```sh
docker stack rm prom
docker volume prune
docker swarm leave --force # If swarm is not needed anymore
```

## Outcome
Prometheus can now scrape the Openshift API server from outside using the bearer token of the generated serviceaccount with the `cluster-reader` role. However the subsequent scrapes of the discovered nods, pods and services fail with an `403 unauthorized` error.

Further debugging using `curl` shows, that the API can be queried, but accessing the endpoint via API proxy results in `403 unauthorized`:
```sh
TOKEN=$(cat token); curl -k -v --header "Authorization: Bearer $TOKEN" https://192.168.64.27:8443/api/
{
  "kind": "APIVersions",
  "versions": [
    "v1"
  ],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "192.168.64.27:8443"
    }
  ]
* Connection #0 to host 192.168.64.27 left intact
}
```

Getting info about `kube-state-metrics`:
```sh
TOKEN=$(cat token); curl -k -v --header "Authorization: Bearer $TOKEN" https://192.168.64.27:8443/api/v1/namespaces/monitoring/services/kube-state-metrics/
{
  "kind": "Service",
  "apiVersion": "v1",
  "metadata": {
    "name": "kube-state-metrics",
    "namespace": "monitoring",
    "selfLink": "/api/v1/namespaces/monitoring/services/kube-state-metrics",
    "uid": "1ecbdec1-23c2-11e8-bd5c-42b58506fb44",
    "resourceVersion": "2547",
    "creationTimestamp": "2018-03-09T17:48:48Z",
    "labels": {
      "app": "prometheus"
    },
    "annotations": {
      "openshift.io/generated-by": "OpenShiftNewApp",
      "prometheus.io/port": "8080",
      "prometheus.io/scrape": "true"
    }
  },
  "spec": {
    "ports": [
      {
        "name": "kube-state-metrics",
        "protocol": "TCP",
        "port": 8080,
        "targetPort": 8080
      }
    ],
    "selector": {
      "name": "kube-state-metrics"
    },
    "clusterIP": "172.30.123.20",
    "type": "ClusterIP",
    "sessionAffinity": "None"
  },
  "status": {
    "loadBalancer": {}
  }
* Connection #0 to host 192.168.64.27 left intact
}
```

However, accessing using the API proxy does not work, the HTTP error code is `403`:
```sh
TOKEN=$(cat token); curl -k -v --header "Authorization: Bearer $TOKEN" https://192.168.64.27:8443/api/v1/namespaces/monitoring/services/kube-state-metrics/proxy/metrics
User "system:serviceaccount:monitoring:prometheus" cannot get services/proxy in the namespace "monitoring": User "system:serviceaccount:monitoring:prometheus" cannot get services/proxy in project "monitoring"
```

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
docker service logs -f prom_prometheus
docker ps
docker exec -it INFLUX_CONTAINERID influx
```

## TODO
- probably easier: oc serviceaccounts get-token prometheus (https://docs.openshift.com/container-platform/3.7/rest_api/index.html)
- what's the difference between /api/v1 and /oapi/v1? (https://docs.openshift.com/container-platform/3.7/rest_api/index.html)
- is there no cluster-reader? https://docs.openshift.com/container-platform/3.7/architecture/additional_concepts/authorization.html#roles
- identify needed role or access rights to access all node, pods and enpoints via API proxy
- https://docs.openshift.com/container-platform/3.7/admin_guide/manage_rbac.html
- https://kubernetes.io/docs/admin/authorization/rbac/
- tune/fix prometheus relabeling, as for example kube-state-metrics service is accessible via `api/v1/namespaces/monitoring/services/kube-state-metrics/proxy/metrics` and not `api/v1/namespaces/monitoring/services/kube-state-metrics:8080/proxy/metrics` 
- add node_exporter DaemonSet
- enable Grafana
- enable alertmanager

## Bugs found
