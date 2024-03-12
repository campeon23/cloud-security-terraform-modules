resource "google_service_account" "service_account" {
  account_id   = "binauthz-gar-sa"
  display_name = "Service Account for GAR"
}

resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.GCP_PROJECT_ID
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
