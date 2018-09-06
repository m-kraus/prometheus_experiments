docker-compose up
docker-compose down -v

Initialize a DB first:
curl -X POST http://localhost:7201/api/v1/database/create -d '{
  "type": "local",
  "namespaceName": "default",
  "retentionTime": "48h"
}'

approx. 5 Minutes after start:
Sun Aug 12 13:13:46 UTC 2018
2.6M    experiment_prometheus_influx_vs_m3_meta-influxdb_data/
151.3M  experiment_prometheus_influx_vs_m3_meta-m3db_data/

Sun Aug 12 13:20:12 UTC 2018
4.5M    experiment_prometheus_influx_vs_m3_meta-influxdb_data/
154.8M  experiment_prometheus_influx_vs_m3_meta-m3db_data/

Sun Aug 12 13:27:04 UTC 2018
6.6M    experiment_prometheus_influx_vs_m3_meta-influxdb_data/
158.2M  experiment_prometheus_influx_vs_m3_meta-m3db_data/

Sun Aug 12 13:35:20 UTC 2018
9.1M    experiment_prometheus_influx_vs_m3_meta-influxdb_data/
162.6M  experiment_prometheus_influx_vs_m3_meta-m3db_data/

Sun Aug 12 13:43:08 UTC 2018
11.5M   experiment_prometheus_influx_vs_m3_meta-influxdb_data/
166.8M  experiment_prometheus_influx_vs_m3_meta-m3db_data/