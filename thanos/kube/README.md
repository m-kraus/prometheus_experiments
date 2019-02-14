
# Kubernetes demo

To bring up this kubernetes demo you will need ```minikube``` https://kubernetes.io/docs/setup/minikube/

Configure it with at least 4G of memory:
```
minikube config set memory 4096
```

Then make a copy of the sample storage configuration file:
```
cp bucket-config.sample bucket-config
```

Fill it with sane values according to https://github.com/improbable-eng/thanos/blob/master/docs/storage.md - create a storage bucket as desribed there.

Then start your kubernetes cluster:
```
minikube start
```

And in the last step, run the deployment script, that will create all necessary objects from the configuration files provided here:
```
./deploy.sh
```

You may now call the kubernetes dashboard:
```
minikube dashboard
```

Or access the generated services:
```
minikube service -n monitoring prometheus
minikube service -n monitoring thanos-query
```