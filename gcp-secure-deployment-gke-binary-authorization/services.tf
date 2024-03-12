resource "google_project_service" "gcp_services" {
  for_each = toset([
    "container.googleapis.com",
    "containeranalysis.googleapis.com",
    "binaryauthorization.googleapis.com",
    "artifactregistry.googleapis.com", // Added Artifact Registry
  ])

  service = each.value

  disable_on_destroy = false
}