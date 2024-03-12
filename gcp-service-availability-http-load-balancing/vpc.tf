# resource "google_project" "my_first_project" {
#   name       = "My First Project"
#   project_id = var.GCP_PROJECT_ID
# }

resource "google_compute_network" "eccnetwork" {
  name                    = "eccnetwork"
  auto_create_subnetworks = true
}