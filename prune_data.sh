#!/bin/bash

rm -rf  ./data/grafana
rm -rf  ./data/influxdb
rm -rf  ./data/prometheus-inner
rm -rf  ./data/prometheus-outer

mkdir -p ./data/grafana
mkdir -p ./data/influxdb
mkdir -p ./data/prometheus-inner
mkdir -p ./data/prometheus-outer

touch ./data/grafana/.gitignore
touch ./data/influxdb/.gitignore
touch ./data/prometheus-inner/.gitignore
touch ./data/prometheus-outer/.gitignore
