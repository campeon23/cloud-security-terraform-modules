variable "GCP_PROJECT_ID" {
  description = "GCP Project ID"
  type        = string
  default     = "my-first-project-391202"
}

variable "GCP_REGION" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "GCP_ZONE" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-b"
}

variable "GCP_LOCATION" {
  description = "GCP Location"
  type        = string
  default     = "us-central1"
}

variable "GCP_CREDENTIALS" {
  description = "GCP Credentials"
  type        = string
  default     = "/opt/gcp/.gcp/my-first-project-391202-35032545eb74.json"
}

variable "image_digest" {
  description = "The digest of the Docker image to deploy"
  type        = string
  default     = "sha256:2b9497941650a7021f062cc5665c984f7f8d4033558589244843f91410ce93fb"
}

variable "GCP_SERVICE_ACCOUNT" {
  description = "value"
  type        = string
  default     = "terraform@my-first-project-391202.iam.gserviceaccount.com"
}

variable "GCP_ARTIFACT_REGISTRY_REPOSITORY" {
  description = "Google Cloud Artifact Registry Repository"
  type        = string
  default     = "ecccloudlab"
}

variable "authorized_networks"  {
  description = "Authorized networks"
  type        = map(string)
  default     = {
    "172.16.0.0/12": "myOffice"
  }
}

variable "create_key_ring" {
  description = "A boolean flag to indicate whether to create a new key ring if it doesn't exist"
  type        = bool
  default     = false  # Set the default value as needed
}

variable "create_key" {
  description = "A boolean flag to indicate whether to create a new key if it doesn't exist"
  type        = bool
  default     = false  # Set the default value as needed
}

variable "key_ring_name" {
  description = "The name of the key ring to create"
  type        = string
  default     = "binauthz-keys-lab-v11"
}

variable "symm_crypto_key_name" {
  description = "The name of the symmetric key to create"
  type        = string
  default     = "symm-key-lab-v11"
}

variable "asym_crypto_key_name" {
  description = "The name of the asymmetric key to create"
  type        = string
  default     = "asym-key-lab-v11"
}