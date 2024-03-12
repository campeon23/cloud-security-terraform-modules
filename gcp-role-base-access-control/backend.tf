terraform {
    backend "gcs" {
        bucket  = "wildb-terraform-state-bucket"
        prefix     = "terrafom/gcp-role-base-access-control/terraform.tfstate"
        credentials = "/opt/gcp/.gcp/my-first-project-391202-35032545eb74.json"
    }
    required_version = "~>1.6.6"
    required_providers {
            google = {
                version = "~> 5.0.0"
            }
    }
}

