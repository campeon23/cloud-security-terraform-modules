resource "google_container_analysis_note" "attestation" {
  name = "binauthz-note"
  project = var.GCP_PROJECT_ID

  attestation_authority {
    hint {
      human_readable_name = "This note represents an attestation authority"
    }
  }
}

resource "google_binary_authorization_attestor" "attestor" {
  name = "binauthz-attestor"
  project = var.GCP_PROJECT_ID
  attestation_authority_note {
    note_reference = "projects/${var.GCP_PROJECT_ID}/notes/${google_container_analysis_note.attestation.name}"
    public_keys {
      # id = data.google_kms_crypto_key_version.version.id
      id = length(data.google_kms_crypto_key_version.version) > 0 ? data.google_kms_crypto_key_version.version.id : ""
      pkix_public_key {
        # public_key_pem      = data.google_kms_crypto_key_version.version.public_key[0].pem
        # signature_algorithm = data.google_kms_crypto_key_version.version.public_key[0].algorithm
        public_key_pem      = length(data.google_kms_crypto_key_version.version) > 0 ? data.google_kms_crypto_key_version.version.public_key[0].pem : ""
        signature_algorithm = length(data.google_kms_crypto_key_version.version) > 0 ? data.google_kms_crypto_key_version.version.public_key[0].algorithm : ""
      }
    }
  }
}

resource "google_kms_crypto_key_iam_binding" "gke_service_account_binding" {
  crypto_key_id = length(data.google_kms_crypto_key.existing_symm_crypto_key) > 0 ? data.google_kms_crypto_key.existing_symm_crypto_key[0].id : google_kms_crypto_key.symm_crypto_key[0].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-934536940649@container-engine-robot.iam.gserviceaccount.com"
  ]
}
