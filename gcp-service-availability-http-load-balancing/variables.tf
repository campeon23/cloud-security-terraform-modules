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

variable "GCP_SECONDDARY_REGION" {
  description = "GCP Region"
  type        = string
  default     = "us-west1"
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

variable "GCP_SERVICE_ACCOUNT" {
  description = "value"
  type        = string
  default     = "terraform@my-first-project-391202.iam.gserviceaccount.com"
}

