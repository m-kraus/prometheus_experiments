FROM thanos-exp/busybox:latest
#FROM quay.io/prometheus/busybox:glibc
LABEL maintainer="The Thanos Authors"

COPY --from=improbable/thanos:master-2018-11-23-94f8503 /bin/thanos /bin/

ENTRYPOINT [ "/bin/thanos" ]
