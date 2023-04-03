#!/bin/bash

kind create cluster --config utils/kind-config.yaml --kubeconfig ~/.kube/config || exit 1
[ "$(kubectl config current-context)" != "kind-kindred" ] && exit 1

ALL=false

while getopts 'a' OPTION; do
    case "$OPTION" in
        a)
            echo "Ok, I'm installing the whole KindRed (-a option)."
            ALL=true
            GRAFANA="y"
            OTEL="y"
            LOKI="y"
            TEMPO="y"
            ENVOY="y"
            JSONLOGGER="y"
            ;;
        ?)
            echo "WTF? Script usage: $(basename $0) [-a]"
            exit 1
            ;;
    esac
done

if [ $ALL = false ]; then
    printf "\n"
    read -p "Install Grafana? [y/n]: " GRAFANA
    printf "\n"
    read -p "Install an OpenTelemetry collector (for logs and tracing)? [y/n]: " OTEL
    printf "\n"
    read -p "Install Loki? [y/n]: " LOKI
    printf "\n"
    read -p "Install Tempo? [y/n]: " TEMPO
    printf "\n"
    read -p "Install an Envoy API Gateway? [y/n]: " ENVOY
    printf "\n"
    read -p "Install a JSON logger? [y/n]: " JSONLOGGER
fi

if [ $GRAFANA = "y" ]; then
    printf "\nInstalling Grafana...\n"
    helm dep up charts/grafana
    helm install --namespace grafana --create-namespace grafana charts/grafana -f charts/grafana/values.yaml
fi

if [ $OTEL = "y" ]; then
    printf "\nInstalling the OpenTelemetry collector...\n"
    helm dep up charts/opentelemetry-collector
    helm install --namespace opentelemetry --create-namespace opentelemetry charts/opentelemetry-collector -f charts/opentelemetry-collector/values.yaml
fi

if [ $LOKI = "y" ]; then
    printf "\nInstalling Loki...\n"
    helm dep up charts/loki
    helm install --namespace loki --create-namespace loki charts/loki -f charts/loki/values.yaml
fi

if [ $TEMPO = "y" ]; then
    printf "\nInstalling Tempo...\n"
    helm dep up charts/tempo
    helm install --namespace tempo --create-namespace tempo charts/tempo -f charts/tempo/values.yaml
fi

printf "\nCreating the acme-kindred namespace...\n"
kubectl create namespace acme-kindred
kubectl label namespace acme-kindred some-namespace-label=kindred

if [ $ENVOY = "y" ]; then
    printf "\nDeploying a minimal Envoy configuration...\n"
    kubectl apply -f envoy-proxy/minimal
    kubectl apply -f envoy-proxy/envoy.deployment.yaml
    kubectl apply -f envoy-proxy/envoy.svc.yaml
fi

if [ $JSONLOGGER = "y" ]; then
    printf "\nDeploying a JSON logger...\n"
    docker build utils/json-logger/ -t json-logger:0.0.1
    kind load docker-image json-logger:0.0.1 --name kindred
    kubectl apply -f log-generators/json
fi

printf "\nHere's an echo server and a log generator, just in case...\n"
kubectl apply -f echo-server
kubectl apply -f log-generators/nginx

kubectl ns acme-kindred

printf "\nAll done!\n"