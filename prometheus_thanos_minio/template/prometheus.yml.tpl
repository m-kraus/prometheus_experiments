global:
  external_labels:
    cluster: cluster
    prometheus: '${PROM_INSTANCE}'
scrape_configs:
- job_name: prometheus
  scrape_interval: 5s
  static_configs:
  - targets:
    - "localhost:9090"
- job_name: thanos-sidecar
  scrape_interval: 5s
  static_configs:
  - targets:
    - "${SIDECAR_INSTANCE}:10902"
- job_name: thanos-store
  scrape_interval: 5s
  static_configs:
  - targets:
    - "store:10902"
- job_name: thanos-query
  scrape_interval: 5s
  static_configs:
  - targets:
    - "query1:10902"
    - "query2:10902"
