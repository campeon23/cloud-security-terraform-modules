resource "google_compute_http_health_check" "default" {
  name               = "ecc-http-health-check"
  request_path       = "/"
  check_interval_sec = 5
  timeout_sec        = 5
  unhealthy_threshold = 2
  healthy_threshold   = 2
}