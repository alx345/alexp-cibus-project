#!/usr/bin/env bash

set -euo pipefail

########################################
# Config
########################################
DOMAIN="${1:-hello-cibus.local}"
NAMESPACE="${2:-production}"
SECRET_NAME="${3:-hello-cibus-tls}"

CERT_DIR="./certs"
DAYS_VALID=365

########################################
# Checks
########################################
echo "[INFO] Checking prerequisites..."

command -v openssl >/dev/null 2>&1 || { echo "❌ openssl not installed"; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "❌ kubectl not installed"; exit 1; }

########################################
# Prepare directory
########################################
mkdir -p "${CERT_DIR}"

CERT_FILE="${CERT_DIR}/tls.crt"
KEY_FILE="${CERT_DIR}/tls.key"

########################################
# Generate certificate
########################################
echo "[INFO] Generating self-signed certificate for domain: ${DOMAIN}"

openssl req -x509 -nodes -days "${DAYS_VALID}" \
  -newkey rsa:2048 \
  -keyout "${KEY_FILE}" \
  -out "${CERT_FILE}" \
  -subj "/CN=${DOMAIN}/O=Cibus" \
  -addext "subjectAltName=DNS:${DOMAIN}"

########################################
# Create / replace Kubernetes secret
########################################
echo "[INFO] Creating TLS secret in namespace '${NAMESPACE}'..."

kubectl create namespace "${NAMESPACE}" >/dev/null 2>&1 || true

kubectl delete secret "${SECRET_NAME}" -n "${NAMESPACE}" >/dev/null 2>&1 || true

kubectl create secret tls "${SECRET_NAME}" \
  --cert="${CERT_FILE}" \
  --key="${KEY_FILE}" \
  -n "${NAMESPACE}"
