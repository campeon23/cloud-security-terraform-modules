resource "kubernetes_namespace" "ecccloudlab_signed" {
  metadata {
    name      = "ecccloudlab-signed"
  }
}

resource "kubernetes_deployment" "hello_eccuser_signed" {
  metadata {
    name = "hello-eccuser-signed"
    namespace = kubernetes_namespace.ecccloudlab_signed.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "hello-eccuser-signed"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-eccuser-signed"
        }

        annotations = {
          "securityContext.seccompProfile" = "runtime/default"
        }
      }

      spec {
        automount_service_account_token = false

        image_pull_secrets {
          name = kubernetes_secret.docker_registry.metadata[0].name
        }

        container {
          image = "${var.GCP_LOCATION}-docker.pkg.dev/${var.GCP_PROJECT_ID}/${var.GCP_ARTIFACT_REGISTRY_REPOSITORY}/hello-eccuser@${var.image_digest}"
          name  = "hello-eccuser-signed"

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }

            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          security_context {
            read_only_root_filesystem = true
            capabilities {
              drop = ["ALL"]
            }
          }

          # readiness_probe {
          #   http_get {
          #     path = "/health"
          #     port = "8080"
          #   }

          #   initial_delay_seconds = 5
          #   period_seconds        = 10
          # }

          # liveness_probe {
          #   http_get {
          #     path = "/health"
          #     port = "8080"
          #   }

          #   initial_delay_seconds = 5
          #   period_seconds        = 10
          # }
        }
      }
    }
  }
}
