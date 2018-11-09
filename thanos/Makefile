.PHONY: build 

all: build

build:
	docker build -t 'thanos-exp/busybox:latest' -f _custom_busybox/Dockerfile _custom_busybox/
	docker build -t 'thanos-exp/prometheus:latest' -f _custom_prometheus/Dockerfile _custom_prometheus/
	docker build -t 'thanos-exp/thanos:latest' -f _custom_thanos/Dockerfile _custom_thanos/
