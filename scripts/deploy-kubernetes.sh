#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f kubernetes/aks/namespace.yaml
kubectl apply -f kubernetes/aks/configmap.yaml
kubectl apply -f kubernetes/aks/customer-api.yaml
kubectl apply -f kubernetes/aks/order-api.yaml
kubectl apply -f kubernetes/aks/notification-worker.yaml
kubectl apply -f kubernetes/aks/kafka-sample.yaml
kubectl apply -f kubernetes/aks/dashboard.yaml
kubectl apply -f kubernetes/aks/ingress.yaml

echo "Platform manifests applied to AKS."
