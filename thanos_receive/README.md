# Thanos experiment

This experiment spins up 3 independent Prometheus instances together
with 3 Grafana instances.

A "meta"-Thanos-receive will ingest metrics from the 3 prometheus
instances via remote_write and persist these data to S3. For
historical access to S3, there is set up a "meta"-Thanos-store. 

Finally a "meta"-Thanos-query is configured to provide a "fleet-wide"
view over all instances.

The minio instance serves as S3 compatible storage.

## Storage options

For a quick start storage in minio is prepared and activated already,
this is done with ```creds/bucket_config.meta```

For storage in GCS or AWS-S3 please have a look at the provided
samples of ```creds/bucket_config.gcs.sample``` and
```creds/bucket_config.s3-aws.sample```. Their options are described
in depth at
<https://github.com/improbable-eng/thanos/blob/master/docs/storage.md>

For Google GCS you have also to provide your credentials in
```creds/gcs-credentials.json```. Please consult
<https://github.com/improbable-eng/thanos/blob/master/docs/storage.md>
for more info.

## Diagram

![Architecture](https://raw.githubusercontent.com/m-kraus/prometheus_experiments/master/thanos_receive/Thanos_Architecture.svg?sanitize=true)

[Draw.io source](Thanos_Architecture.xml)

## Starting the experiment

``` docker-compose up ```

## Accessing the components

You can click on the components in the architecture diagram above.

For minio use the credentials ```THANOS:ITSTHANOSTIME```. For Grafana
use the credentials ```admin:pass```:

### List of components

Minio <http://127.0.0.1:19000/minio/>

Prometheus <http://127.0.0.1:19011> <http://127.0.0.1:19021>
<http://127.0.0.1:19031>

Thanos-query <http://127.0.0.1:19043>

Grafana <http://127.0.0.1:19015> <http://127.0.0.1:19025>
<http://127.0.0.1:19035> and <http://127.0.0.1:19045>

## Stopping the experiment

``` docker-compose down -v ```
