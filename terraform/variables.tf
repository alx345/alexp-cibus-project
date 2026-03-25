#############################
# General
#############################

variable "project_name" {
  description = "Project name prefix for all resources"
  type        = string
  default     = "hello-cibus"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

#############################
# Kubernetes / Minikube
#############################

variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "hello-cibus"
}

#############################
# Application
#############################

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "hellocibus"
}

variable "app_image" {
  description = "Docker image for the application"
  type        = string
  default     = "hellocibus:latest"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 5000
}

variable "replicas" {
  description = "Number of pod replicas"
  type        = number
  default     = 2
}

#############################
# Resources
#############################

variable "cpu_requests" {
  description = "CPU requests"
  type        = string
  default     = "100m"
}

variable "memory_requests" {
  description = "Memory requests"
  type        = string
  default     = "128Mi"
}

variable "cpu_limits" {
  description = "CPU limits"
  type        = string
  default     = "250m"
}

variable "memory_limits" {
  description = "Memory limits"
  type        = string
  default     = "256Mi"
}

#############################
# Service
#############################

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "ClusterIP"
}

variable "service_port" {
  description = "Service port"
  type        = number
  default     = 80
}

#############################
# Ingress
#############################

variable "ingress_enabled" {
  description = "Enable ingress resource"
  type        = bool
  default     = true
}

variable "ingress_host" {
  description = "Ingress hostname"
  type        = string
  default     = "hellocibus.local"
}

#############################
# ArgoCD
#############################

variable "argocd_namespace" {
  description = "Namespace where ArgoCD is installed"
  type        = string
  default     = "argocd"
}

variable "argocd_app_name" {
  description = "ArgoCD application name"
  type        = string
  default     = "hello-cibus-app"
}

variable "repo_url" {
  description = "Git repository URL for ArgoCD"
  type        = string
}

variable "repo_path" {
  description = "Path in repo where manifests are located"
  type        = string
  default     = "k8s"
}

variable "target_revision" {
  description = "Git revision (branch/tag)"
  type        = string
  default     = "main"
}
