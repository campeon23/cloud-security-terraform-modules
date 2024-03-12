variable "GCP_PROJECT_ID" {
  description = "GCP Project ID"
  type        = string
  default     = "my-first-project-391202"
}

variable "GCP_REGION" {
  description = "GCP Region"
  type        = string
  default     = "us-east1"
}

variable "GCP_ZONE" {
  description = "GCP Zone"
  type        = string
  default     = "us-east1-b"
}

variable "GCP_CREDENTIALS" {
  description = "GCP Credentials"
  type        = string
  default     = "/opt/gcp/.gcp/my-first-project-391202-35032545eb74.json"
}