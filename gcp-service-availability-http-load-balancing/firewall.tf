resource "google_compute_firewall" "default_allow_http" {
  name    = "default-allow-http"
  network = google_compute_network.eccnetwork.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http-server"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default_allow_health_check" {
  name    = "default-allow-health-check"
  network = google_compute_network.eccnetwork.name

  allow {
    protocol = "tcp"
  }

  target_tags   = ["http-server"]
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}