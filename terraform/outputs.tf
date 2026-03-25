output "namespace" {
  description = "Kubernetes namespace used for the deployment"
  value       = kubernetes_namespace.production.metadata[0].name
}

output "deployment_name" {
  description = "Deployment name for the helloCibus application"
  value       = kubernetes_deployment.hello_cibus.metadata[0].name
}

output "deployment_replicas" {
  description = "Number of desired replicas for the helloCibus deployment"
  value       = kubernetes_deployment.hello_cibus.spec[0].replicas
}

output "service_name" {
  description = "Service name exposing the helloCibus application"
  value       = kubernetes_service.hello_cibus.metadata[0].name
}

output "service_type" {
  description = "Service type for the helloCibus application"
  value       = kubernetes_service.hello_cibus.spec[0].type
}

output "ingress_name" {
  description = "Ingress name for external access"
  value       = kubernetes_ingress_v1.hello_cibus.metadata[0].name
}

output "ingress_host" {
  description = "Hostname configured for the ingress"
  value       = var.host
}

output "tls_secret_name" {
  description = "TLS secret used by the ingress"
  value       = kubernetes_secret.tls.metadata[0].name
}

output "container_image" {
  description = "Container image used by the deployment"
  value       = var.image
}

output "application_url" {
  description = "HTTPS URL for accessing the application"
  value       = "https://${var.host}"
}
