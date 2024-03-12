output "note_name" {
  description = "value of the note name"
  value = google_container_analysis_note.attestation.name
}

output "attestor_name" {
  description = "value of the attestor name"
  value = google_binary_authorization_attestor.attestor.name
}

output "note_reference" {
  description = "value of the note reference"
  value = google_binary_authorization_attestor.attestor.attestation_authority_note.0.note_reference
}

output "binary_authorization_key_name" {
  description = "value of the note reference"
  value = google_container_cluster.ecc_binary_authorization.database_encryption.0.key_name
}

output "image_name" {
    description = "value of the image name"
    value = kubernetes_deployment.hello_eccuser_signed.spec.0.template.0.spec.0.container.0.image
}

output "service_account_key" {
  description = "value of the service account key"
  value = google_service_account_key.service_account_key.private_key
  sensitive = true
}

output "key_version" {
  description = "value of the key version"
  value       = can(data.google_kms_crypto_key.existing_asym_crypto_key[0].id) ? data.google_kms_crypto_key.existing_asym_crypto_key[0].id : google_kms_crypto_key.asym_crypto_key[0].id
}

output "existing_key_ring_count" {
  description = "value of the existing key ring count"
  value       = length(data.google_kms_key_ring.existing_key_ring) == 0 ? 0 : 1
}

output "existing_symm_crypto_key_count" {
  description = "value of the existing symm crypto key count"
  value       = length(data.google_kms_crypto_key.existing_symm_crypto_key) == 0 ? 0 : 1
}

output "existing_symm_crypto_key_ring" {
  description = "value of the existing symm crypto key key ring"
  value       = "${var.GCP_PROJECT_ID}/${var.GCP_LOCATION}/${var.key_ring_name}"
}

output "existing_asym_crypto_key_count" {
  description = "value of the existing asym crypto key count"
  value       = length(data.google_kms_crypto_key.existing_asym_crypto_key) == 0 ? 0 : 1
}

output "existing_asym_crypto_key_ring" {
  description = "value of the existing asym crypto key key ring"
  value       = "${var.GCP_PROJECT_ID}/${var.GCP_LOCATION}/${var.key_ring_name}"
}

output "key_ring_count" {
  description = "value of the key ring count"
  value       = length(data.google_kms_key_ring.existing_key_ring.*.id) == 0 ? 1 : 0
}

output "symm_crypto_key_count" {
  description = "value of the symm crypto key count"
  value       = length(data.google_kms_crypto_key.existing_symm_crypto_key.*.id) == 0 ? 1 : 0
}

output "symm_crypto_key_ring" {
  description = "value of the symm crypto key key ring"
  value       = "${var.GCP_PROJECT_ID}/${var.GCP_LOCATION}/${var.key_ring_name}"
}

output "asym_crypto_key_count" {
  description = "value of the asym crypto key count"
  value       = length(data.google_kms_crypto_key.existing_asym_crypto_key.*.id) == 0 ? 1 : 0
}

output "asym_crypto_key_ring" {
  description = "value of the asym crypto key key ring"
  value       = "${var.GCP_PROJECT_ID}/${var.GCP_LOCATION}/${var.key_ring_name}"
}
