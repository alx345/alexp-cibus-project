#!/usr/bin/env bash

set -euo pipefail

########################################
# Config
########################################
ARGOCD_NAMESPACE="argocd"
ARGOCD_VERSION="${1:-v2.11.7}"

########################################
# Checks
########################################
echo "[INFO] Checking prerequisites..."

command -v kubectl >/dev/null 2>&1 || { echo "❌ kubectl not installed"; exit 1; }

########################################
# Ensure cluster is reachable
########################################
echo "[INFO] Verifying Kubernetes connectivity..."
kubectl cluster-info >/dev/null 2>&1 || {
  echo "❌ Kubernetes cluster is not reachable"
  exit 1
}

########################################
# Create namespace if needed
########################################
echo "[INFO] Creating namespace '${ARGOCD_NAMESPACE}' if not exists..."
kubectl get namespace "${ARGOCD_NAMESPACE}" >/dev/null 2>&1 || \
kubectl create namespace "${ARGOCD_NAMESPACE}"

########################################
# Install ArgoCD
########################################
echo "[INFO] Installing ArgoCD ${ARGOCD_VERSION}..."

kubectl apply -n "${ARGOCD_NAMESPACE}" \
  -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

########################################
# Wait for core components
########################################
echo "[INFO] Waiting for ArgoCD deployments to become available..."

kubectl wait deployment argocd-server \
  -n "${ARGOCD_NAMESPACE}" \
  --for=condition=Available=True \
  --timeout=300s

kubectl wait deployment argocd-repo-server \
  -n "${ARGOCD_NAMESPACE}" \
  --for=condition=Available=True \
  --timeout=300s

kubectl wait deployment argocd-application-controller \
  -n "${ARGOCD_NAMESPACE}" \
  --for=condition=Available=True \
  --timeout=300s

########################################
# Patch service to NodePort for local access
########################################
echo "[INFO] Patching argocd-server service to NodePort..."
kubectl patch svc argocd-server \
  -n "${ARGOCD_NAMESPACE}" \
  -p '{"spec": {"type": "NodePort"}}' >/dev/null

########################################
# Fetch initial admin password
########################################
echo "[INFO] Retrieving initial admin password..."
ADMIN_PASSWORD="$(kubectl -n "${ARGOCD_NAMESPACE}" get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"
