FROM thanos-exp/busybox:latest
#FROM quay.io/prometheus/busybox:glibc
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"

COPY --from=prom/prometheus:v2.4.3 /bin/prometheus                           /bin/
COPY --from=prom/prometheus:v2.4.3 /bin/promtool                             /bin/
COPY --from=prom/prometheus:v2.4.3 /etc/prometheus/prometheus.yml            /etc/prometheus/
COPY --from=prom/prometheus:v2.4.3 /usr/share/prometheus/console_libraries/* /usr/share/prometheus/console_libraries/
COPY --from=prom/prometheus:v2.4.3 /usr/share/prometheus/consoles/*          /usr/share/prometheus/consoles/

RUN ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/
RUN mkdir -p /prometheus && \
    chown -R nobody:nogroup etc/prometheus /prometheus

USER       nobody
EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--web.console.libraries=/usr/share/prometheus/console_libraries", \
             "--web.console.templates=/usr/share/prometheus/consoles" ]
