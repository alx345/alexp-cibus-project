terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27"
    }
  }
}

# Use local kubeconfig (Minikube)
provider "kubernetes" {
  config_path = "~/.kube/config"
}
