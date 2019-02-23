global:
  external_labels:
    company: acme
    cluster: "$(CLUSTER)"
    replica: "$(REPLICA)"
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
    - "$(CLUSTER)-sidecar:10902"
- job_name: thanos-store
  scrape_interval: 5s
  static_configs:
  - targets:
    - "$(CLUSTER)-store:10902"
- job_name: thanos-query
  scrape_interval: 5s
  static_configs:
  - targets:
    - "$(CLUSTER)-query:10902"
