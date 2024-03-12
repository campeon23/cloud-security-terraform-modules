resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_logging_project_sink" "audit_logs_sink" {
  name        = "compute-engine-audit-logs-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.audit_logs.name}"

  filter = "logName:\"logs/cloudaudit.googleapis.com\" AND resource.type=\"gce_instance\" AND protoPayload.serviceName=\"compute.googleapis.com\""

  unique_writer_identity = true

  depends_on = [google_project_service.compute]
}

resource "google_storage_bucket" "audit_logs" {
  name    = "ecc-audit-logs-bucket-${random_id.bucket_suffix.hex}"
  location = var.GCP_LOCATION

    // Enable logging
    logging {
        log_bucket = "log-bucket-name"  // replace with your log bucket name
    }

    // Enable versioning
    versioning {
        enabled = true
    }

    // Enable uniform bucket-level access
    uniform_bucket_level_access = true
}

resource "random_id" "bucket_suffix" {
    byte_length = 2
}

# resource "google_project_iam_policy" "audit_log_viewer" {
#     project = var.GCP_PROJECT_ID
#     policy_data = data.google_iam_policy.audit_log_viewer.policy_data
# }

resource "google_project_iam_binding" "audit_log_viewer" {
  project = var.GCP_PROJECT_ID
  role    = "roles/logging.viewer"

  members = [
    "${google_logging_project_sink.audit_logs_sink.writer_identity}",
  ]
  depends_on = [google_logging_project_sink.audit_logs_sink]
}

data "google_iam_policy" "audit_log_viewer" {
    binding {
        role = "roles/logging.viewers"
        members = [
            "serviceAccount:${google_logging_project_sink.audit_logs_sink.writer_identity}",
        ]
    }
}