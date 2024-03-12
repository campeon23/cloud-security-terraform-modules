data "google_kms_crypto_key_version" "version" {
  crypto_key = can(data.google_kms_crypto_key.existing_asym_crypto_key[0].id) ? data.google_kms_crypto_key.existing_asym_crypto_key[0].id : google_kms_crypto_key.asym_crypto_key[0].id
}

data "google_kms_key_ring" "existing_key_ring" {
  count    = length(data.google_kms_key_ring.existing_key_ring) == 0 ? 0 : 1
  name     = var.key_ring_name
  location = var.GCP_LOCATION
}

data "google_kms_crypto_key" "existing_symm_crypto_key" {
  count    = length(data.google_kms_crypto_key.existing_symm_crypto_key) == 0 ? 0 : 1
  name     = var.symm_crypto_key_name
  key_ring = "${var.GCP_PROJECT_ID}/${var.GCP_LOCATION}/${var.key_ring_name}"
}

data "google_kms_crypto_key" "existing_asym_crypto_key" {
  count    = length(data.google_kms_crypto_key.existing_asym_crypto_key) == 0 ? 0 : 1
  name     = var.asym_crypto_key_name
  key_ring = "${var.GCP_PROJECT_ID}/${var.GCP_LOCATION}/${var.key_ring_name}"
}

resource "google_kms_key_ring" "key_ring" {
  count    = length(data.google_kms_key_ring.existing_key_ring.*.id) == 0 ? 1 : 0
  name     = var.key_ring_name
  location = var.GCP_LOCATION
}

resource "google_kms_crypto_key" "symm_crypto_key" {
  count           = length(data.google_kms_crypto_key.existing_symm_crypto_key.*.id) == 0 ? 1 : 0
  name            = var.symm_crypto_key_name
  key_ring        = "${var.GCP_PROJECT_ID}/${var.GCP_LOCATION}/${var.key_ring_name}"
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = "172800s"
  
  version_template {
    algorithm = "GOOGLE_SYMMETRIC_ENCRYPTION"
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [ google_kms_key_ring.key_ring ]
}

resource "google_kms_crypto_key" "asym_crypto_key" {
  count           = length(data.google_kms_crypto_key.existing_asym_crypto_key.*.id) == 0 ? 1 : 0
  name            = var.asym_crypto_key_name
  key_ring        = "${var.GCP_PROJECT_ID}/${var.GCP_LOCATION}/${var.key_ring_name}"
  purpose         = "ASYMMETRIC_SIGN"
  # rotation_period = "172800s"
  
  version_template {
    algorithm = "EC_SIGN_P384_SHA384"
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [ google_kms_key_ring.key_ring ]
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "kubernetes_secret" "docker_registry" {
  metadata {
    name = "gar-json-key"
    namespace = kubernetes_namespace.ecccloudlab_signed.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://${var.GCP_LOCATION}-docker.pkg.dev" = {
        auth = base64encode("json_key:${google_service_account_key.service_account_key.private_key}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}
