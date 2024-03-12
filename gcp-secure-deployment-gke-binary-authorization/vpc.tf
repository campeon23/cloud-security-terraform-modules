resource "google_compute_network" "ecc_vpc_network" {
  name                    = "ecc-vpc-network"
  auto_create_subnetworks = false  // Set to false to manually create subnetworks
}

resource "google_compute_subnetwork" "ecc_subnetwork" {
  name                     = "ecc-subnetwork"
  region                   = var.GCP_REGION
  network                  = google_compute_network.ecc_vpc_network.name
  ip_cidr_range            = "10.0.0.0/16"

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.2.0.0/20"
  }
}
