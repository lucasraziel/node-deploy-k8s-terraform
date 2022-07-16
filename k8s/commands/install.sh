#!/bin/bash
kubectl apply -f $PWD/k8s/namespace.yml
kubectl apply -f $PWD/k8s/security.yml
sed -e 's/^/export /' $PWD/.env >> $PWD/.env.temp
source $PWD/.env.temp
rm $PWD/.env.temp
envsubst < $PWD/k8s/config-env-filebeats.yml | kubectl apply -f -
kubectl apply -f $PWD/k8s/filebeats.yml
envsubst < $PWD/k8s/config-env.yml | kubectl apply -f -
envsubst < $PWD/k8s/config-db.yml | kubectl apply -f -
kubectl apply -f $PWD/k8s/config-initdb.yml
kubectl apply -f $PWD/k8s/pvc.yml
envsubst < $PWD/k8s/deploymentpg.yml | kubectl apply -f -
kubectl apply -f $PWD/k8s/servicepg.yml
kubectl apply -f $PWD/k8s/deployment.yml
kubectl apply -f $PWD/k8s/service.yml
kubectl apply -f $PWD/k8s/hpa.yml
kubectl apply -f $PWD/k8s/prometheus.yml
kubectl apply -f $PWD/k8s/grafana.yml
kubectl apply -f $PWD/k8s/nodeExporter.yml
kubectl create -n appzone secret docker-registry \
   --dry-run=client \
   appzone-ghcr-secret  --docker-username=$GITHUB_USER \
   --docker-server=ghcr.io  --docker-email=lucas.sr.rg@gmail.com \
   --docker-password=$CR_PAT  -o yaml \
   | kubectl apply -f -
#kubectl apply -f $PWD/k8s/cert-manager.yml
#kubectl apply -f $PWD/k8s/mandatory-nginx-ingress.yml
#kubectl apply -f $PWD/k8s/nginx-ingress.yml
#sleep 30
#kubectl apply -f $PWD/k8s/cert-issuer.yml
#kubectl apply -f $PWD/k8s/external-dns.yml





