# Thanos experiment

This expermient spins up 3 independent Prometheus instances together with 3 Thaons-sidecars. On kubernetes this would be best within the same Pod.
Additinally a Thanos-store und two Thanos-queries are configured. A Thanos-compact is defined, but commented out at the moment.

For "long-term"-storage there is also a minio instance, which is configured through ```creds/minio.yaml``` for the Thanos-sidecars and Thanos-store.

## Storage options

Storage in Google GCS is prepared. Uncomment the environment variable ```GOOGLE_APPLICATION_CREDENTIALS``` in the file ```docker-compose.yaml``` and configure ```creds/gcs-credentials.json.sample``` and ```creds/gcs.yaml.sample``` accordingly.

You can also change ```creds/minio.yaml``` to match your Amazon S3 configuration. See (https://github.com/improbable-eng/) for details.

## Starting the experiment

As always run ```docker-compose up```.

## Accessing the components

Access minio store in your browser via (http://127.0.0.1:19000/minio/) using the credentials ```THANOS:ITSTHANOSTIME```.

The independent Prometheus instances are accessible via (http://127.0.0.1:9091) (http://127.0.0.1:9092) (http://127.0.0.1:9093).

The Thanos-query instances are accessible via (http://127.0.0.1:19195) (http://127.0.0.1:19196).

## Cleaning up

For cleaning up data written in the directory ```data/``` please run ```cleanup.sh```.