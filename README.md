# 🚀 Cibus GitOps Assignment – helloCibus Service

## 📌 Overview

This project demonstrates a **GitOps-driven deployment workflow** on a local Kubernetes cluster using **Minikube**, **ArgoCD**, and **Infrastructure as Code (IaC)** principles.

The solution includes:

* A lightweight Python REST API (`helloCibus`)
* Containerized application (non-root, production-ready)
* Kubernetes manifests for deployment
* HTTPS Ingress with TLS termination (self-signed certificate)
* ArgoCD for continuous delivery (GitOps)

---

## 🏗️ Architecture

The system follows a GitOps model where **Git is the single source of truth**.

**Flow:**

```
Developer → Git Repository → ArgoCD → Kubernetes (Minikube)
→ Ingress (HTTPS) → Service → Pod (helloCibus)
```

Architecture diagram is available under:

```
docs/architecture.drawio
docs/architecture.png
```

---

## 📂 Repository Structure

```
cibus-gitops-assignment/
├── helloCibus/                # Python REST API
├── terraform/                 # Infrastructure as Code
├── k8s/                       # Kubernetes manifests
├── docs/                      # Architecture diagram
├── scripts/                   # Helper scripts
└── README.md
```

---

## ⚙️ Prerequisites

Make sure you have the following installed:

* Docker
* Minikube
* kubectl
* Terraform
* Git
* (Optional) Helm

---

## 🚀 Setup Instructions

### 1. Start Minikube

```bash
minikube start --driver=docker
```

Enable ingress:

```bash
minikube addons enable ingress
```

---

### 2. Build Docker Image

```bash
eval $(minikube docker-env)

docker build -t hello-cibus:latest ./helloCibus
```

---

### 3. Generate TLS Certificate (self-signed)

```bash
./scripts/generate-self-signed-cert.sh
```

This creates a Kubernetes TLS secret used by Ingress.

---

### 4. Deploy Infrastructure

Apply namespace and app resources:

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/
```

---

### 5. Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Access ArgoCD UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Get admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d
```

---

### 6. Deploy Application via ArgoCD

Apply ArgoCD application:

```bash
kubectl apply -f k8s/argocd-application.yaml
```

ArgoCD will:

* Monitor the Git repository
* Automatically sync changes
* Deploy updates to the cluster

---

## 🌐 Access the Application

Get Minikube IP:

```bash
minikube ip
```

Add to `/etc/hosts`:

```
<MINIKUBE_IP> hello-cibus.local
```

Access:

```
https://hello-cibus.local
```

---

## 🔒 HTTPS & TLS

* HTTP traffic (port 80) is redirected to HTTPS (443)
* TLS is terminated at the Ingress layer
* Certificate is stored as a Kubernetes Secret

---

## 🧪 API Endpoints

| Endpoint  | Description              |
| --------- | ------------------------ |
| `/`       | Returns greeting message |
| `/health` | Health check             |

Example:

```bash
curl -k https://hello-cibus.local
```

Response:

```
Hello, I'm Cibus service
```

---

## 🔁 GitOps Workflow

1. Developer pushes changes to Git
2. ArgoCD detects changes
3. ArgoCD syncs cluster state
4. Kubernetes updates resources automatically

No manual `kubectl` is required in steady state.

---

## 🧠 Key Design Decisions

* **Non-root container** → improved security
* **Ingress TLS termination** → offloads HTTPS from app
* **GitOps via ArgoCD** → declarative, automated deployment
* **Separation of concerns**:

  * App code (`helloCibus/`)
  * Infrastructure (`terraform/`)
  * Kubernetes manifests (`k8s/`)

---

## 📌 Notes

* This solution is designed for **local development (Minikube)**
* In production, TLS would be handled by a trusted CA (e.g., Let's Encrypt)
* Image registry can be added for remote deployments

---

## ✅ Deliverables Covered

✔ System architecture diagram
✔ Python web service
✔ Terraform + Kubernetes manifests
✔ Ingress with TLS
✔ ArgoCD GitOps deployment
✔ Full setup instructions

---

## 👤 Author

Alexander Perlin
Senior DevOps Engineer

---
