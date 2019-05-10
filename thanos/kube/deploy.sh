#!/bin/bash

export KUBECONFIG=.kubeconfig

echo -n "Creating namespace..."
kubectl create -f 00-base/monitoring-namespace.yaml

echo -n "Creating secret..."
kubectl create secret -n monitoring generic s3-creds --from-file=./bucket_config

echo -n "Deploying node_exporter..."
kubectl create -f 01-node_exporter/node-exporter-daemonset.yaml
kubectl create -f 01-node_exporter/node-exporter-service.yaml

echo -n "Deploying prometheus with thanos sidecar..."
kubectl create -f 02-prometheus/prometheus-rbac.yaml
kubectl create -f 02-prometheus/prometheus-configmap.yaml
kubectl create -f 02-prometheus/prometheus-rules-configmap.yaml
kubectl create -f 02-prometheus/prometheus-statefulset.yaml
kubectl create -f 02-prometheus/prometheus-service.yaml

echo -n "Deploying kube-state-metrics..."
kubectl create -f 03-kube-state-metrics/kube-state-metrics-rbac.yaml
kubectl create -f 03-kube-state-metrics/kube-state-metrics-deployment.yaml
kubectl create -f 03-kube-state-metrics/kube-state-metrics-service.yaml

echo -n "Deploying thanos query..."
kubectl create -f 04-query/thanos-query-deployment.yaml
kubectl create -f 04-query/thanos-query-service.yaml

echo -n "Deploying thanos store..."
kubectl create -f 05-store/thanos-store-deployment.yaml
kubectl create -f 05-store/thanos-store-service.yaml

echo -n "Deploying alertmanager..."
kubectl create -f 06-alertmanager/alertmanager-pvc.yaml
kubectl create -f 06-alertmanager/alertmanager-configmap.yaml
kubectl create -f 06-alertmanager/alertmanager-deployment.yaml
kubectl create -f 06-alertmanager/alertmanager-service.yaml
