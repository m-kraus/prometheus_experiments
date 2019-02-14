minikube config set memory 4096

cp bucket-config.sample bucket-config

Fill the newly generated files with sane values according to https://github.com/improbable-eng/thanos/blob/master/docs/storage.md

minikube start

./deploy.sh
