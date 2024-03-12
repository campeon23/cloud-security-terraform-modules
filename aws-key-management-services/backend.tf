terraform {
    backend "s3" {
        bucket  = "wildb-terraform-state-bucket"
        key     = "terrafom/aws-key-management-services/terraform.tfstate"
        region  = "us-east-1"
        profile = "terraform"
    }
}