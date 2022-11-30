#!/bin/bash

kind create cluster --config utils/kind-config.yaml --kubeconfig ~/.kube/config || exit 1
[ "$(kubectl config current-context)" != "kind-kindred" ] && exit 1

kubectl create namespace kindred

while getopts m: flag
do
    case "${flag}" in
        m) mode=${OPTARG};;
    esac
done

if [ $mode = "minimal" ] 
then
    echo "Deploying minimal Envoy configuration..."
    kubectl apply -f envoy-proxy/minimal -n kindred
else
    echo "Deploying standard Envoy configuration..."
    kubectl apply -f envoy-proxy/standard -n kindred
fi

kubectl apply -f envoy-proxy/envoy.deployment.yaml
kubectl apply -f envoy-proxy/envoy.svc.yaml
kubectl apply -f echo-server
kubectl apply -f nginx-logger

helm install --namespace loki --create-namespace loki charts/loki -f charts/loki/values.yaml
helm install --namespace grafana --create-namespace grafana charts/grafana -f charts/grafana/values.yaml
helm install --namespace opentelemetry --create-namespace opentelemetry charts/opentelemetry-collector -f charts/opentelemetry-collector/values.yaml

kubectl ns kindred