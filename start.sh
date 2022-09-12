#!/bin/bash

kind create cluster --config utils/kind-config.yaml --kubeconfig ~/.kube/config || exit 1
[ "$(kubectl config current-context)" != "kind-kindergarten" ] && exit 1

kubectl create namespace kindergarten

while getopts m: flag
do
    case "${flag}" in
        m) mode=${OPTARG};;
    esac
done

if [ $mode = "minimal" ] 
then
    echo "Deploying minimal Envoy configuration..."
    kubectl apply -f envoy-proxy/minimal -n kindergarten
else
    echo "Deploying standard Envoy configuration..."
    kubectl apply -f envoy-proxy/standard -n kindergarten
fi

kubectl apply -f envoy-proxy/envoy.deployment.yaml -n kindergarten
kubectl apply -f envoy-proxy/envoy.svc.yaml -n kindergarten
kubectl apply -f echo-server -n kindergarten

kubectl ns kindergarten