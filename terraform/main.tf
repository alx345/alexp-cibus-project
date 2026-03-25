terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

########################################
# Namespace
########################################
resource "kubernetes_namespace" "production" {
  metadata {
    name = var.namespace
  }
}

########################################
# Deployment - helloCibus app
########################################
resource "kubernetes_deployment" "hello_cibus" {
  metadata {
    name      = "hello-cibus"
    namespace = kubernetes_namespace.production.metadata[0].name
    labels = {
      app = "hello-cibus"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "hello-cibus"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-cibus"
        }
      }

      spec {
        container {
          name  = "hello-cibus"
          image = var.image

          port {
            container_port = 5000
          }

          security_context {
            run_as_non_root = true
            run_as_user     = 1000
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

########################################
# Service
########################################
resource "kubernetes_service" "hello_cibus" {
  metadata {
    name      = "hello-cibus-service"
    namespace = kubernetes_namespace.production.metadata[0].name
  }

  spec {
    selector = {
      app = "hello-cibus"
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "ClusterIP"
  }
}

########################################
# TLS Secret (self-signed cert)
########################################
resource "kubernetes_secret" "tls" {
  metadata {
    name      = "hello-cibus-tls"
    namespace = kubernetes_namespace.production.metadata[0].name
  }

  data = {
    "tls.crt" = filebase64(var.tls_crt_path)
    "tls.key" = filebase64(var.tls_key_path)
  }

  type = "kubernetes.io/tls"
}

########################################
# Ingress (HTTPS + redirect)
########################################
resource "kubernetes_ingress_v1" "hello_cibus" {
  metadata {
    name      = "hello-cibus-ingress"
    namespace = kubernetes_namespace.production.metadata[0].name

    annotations = {
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = [var.host]
      secret_name = kubernetes_secret.tls.metadata[0].name
    }

    rule {
      host = var.host

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.hello_cibus.metadata[0].name

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
