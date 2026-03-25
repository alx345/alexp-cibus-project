#!/usr/bin/env bash

set -euo pipefail

########################################
# Config
########################################
PROFILE="cibus"
K8S_VERSION="v1.29.0"
CPUS="4"
MEMORY="8192"
DRIVER="docker"

########################################
# Checks
########################################
echo "[INFO] Checking prerequisites..."

command -v minikube >/dev/null 2>&1 || { echo "❌ minikube not installed"; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "❌ kubectl not installed"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "❌ docker not installed"; exit 1; }

########################################
# Start Minikube
########################################
echo "[INFO] Starting Minikube cluster..."

minikube start \
  --profile="${PROFILE}" \
  --kubernetes-version="${K8S_VERSION}" \
  --cpus="${CPUS}" \
  --memory="${MEMORY}" \
  --driver="${DRIVER}" \
  --addons=ingress

########################################
# Enable required addons
########################################
echo "[INFO] Enabling addons..."

minikube -p "${PROFILE}" addons enable ingress
minikube -p "${PROFILE}" addons enable metrics-server

########################################
# Configure Docker env (for local builds)
########################################
echo "[INFO] Configuring Docker environment..."
eval "$(minikube -p "${PROFILE}" docker-env)"

########################################
# Wait for cluster readiness
########################################
echo "[INFO] Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s

########################################
# Namespace (production)
########################################
echo "[INFO] Creating namespace 'production' if not exists..."
kubectl get namespace production >/dev/null 2>&1 || \
kubectl create namespace production
