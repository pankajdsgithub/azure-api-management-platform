#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="${1:-rg-platform-prod}"
LOCATION="${2:-eastus2}"
CLUSTER_NAME="${3:-aks-prod-eastus2}"
NODE_COUNT="${4:-3}"

az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
az aks create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CLUSTER_NAME" \
  --location "$LOCATION" \
  --node-count "$NODE_COUNT" \
  --generate-ssh-keys

az aks get-credentials --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME" --overwrite-existing

echo "AKS cluster '$CLUSTER_NAME' is ready."
echo "Use: kubectl apply -f kubernetes/aks/"
