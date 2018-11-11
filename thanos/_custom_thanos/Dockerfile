FROM thanos-exp/busybox:latest
#FROM quay.io/prometheus/busybox:glibc
LABEL maintainer="The Thanos Authors"

COPY --from=improbable/thanos:master-2018-11-08-3bb4076 /bin/thanos /bin/

ENTRYPOINT [ "/bin/thanos" ]
