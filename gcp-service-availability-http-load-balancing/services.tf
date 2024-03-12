resource "google_compute_backend_service" "default" {
  name        = "ecc-http-backend"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_http_health_check.default.id]

  backend {
    group = google_compute_instance_group_manager.eccmg[var.GCP_REGION].instance_group
  }

  backend {
    group = google_compute_instance_group_manager.eccmg[var.GCP_SECONDDARY_REGION].instance_group
  }
}
