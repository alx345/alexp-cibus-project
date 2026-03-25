#!/usr/bin/env bash

set -euo pipefail

########################################
# Config
########################################
PROFILE="cibus"
IMAGE_NAME="hello-cibus"
IMAGE_TAG="${1:-latest}"
FULL_IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"

########################################
# Checks
########################################
echo "[INFO] Checking prerequisites..."

command -v minikube >/dev/null 2>&1 || { echo "❌ minikube not installed"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "❌ docker not installed"; exit 1; }

########################################
# Verify Minikube profile exists
########################################
if ! minikube profile list | grep -q "^${PROFILE}\b"; then
  echo "❌ Minikube profile '${PROFILE}' not found."
  echo "Run ./scripts/start-minikube.sh first."
  exit 1
fi

########################################
# Use Minikube Docker daemon
########################################
echo "[INFO] Switching shell to Minikube Docker daemon..."
eval "$(minikube -p "${PROFILE}" docker-env)"

########################################
# Build image inside Minikube Docker
########################################
echo "[INFO] Building Docker image: ${FULL_IMAGE}"
docker build -t "${FULL_IMAGE}" .
