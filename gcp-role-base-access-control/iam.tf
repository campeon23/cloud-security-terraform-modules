resource "google_project_iam_member" "editor_role" {
  project = var.GCP_PROJECT_ID
  role    = "roles/editor"
  member  = "user:ccse.labs.demo@gmail.com"
}

resource "google_project_iam_member" "object_viewer_role" {
  project = var.GCP_PROJECT_ID
  role    = "roles/storage.objectViewer"
  member  = "user:ccse.labs.demo@gmail.com"
}

resource "google_project_iam_custom_role" "app_engine_admin" {
  role_id     = "CustomAppEngineAdmin"
  title       = "Custom Role for App Engine Admin"
  description = "A custom role for App Engine Admin"
  permissions = [
    "accessapproval.requests.approve",
    "accessapproval.settings.delete",
    "accessapproval.settings.update",
  ]
}

resource "google_project_iam_member" "custom_app_engine_admin_role" {
  depends_on = [google_project_iam_custom_role.app_engine_admin]
  project = var.GCP_PROJECT_ID
  role    = "projects/${var.GCP_PROJECT_ID}/roles/CustomAppEngineAdmin"
  member  = "user:ccse.labs.demo@gmail.com"
}