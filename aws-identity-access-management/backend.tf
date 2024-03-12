terraform {
    backend "s3" {
        bucket  = "wildb-terraform-state-bucket"
        key     = "terrafom/aws-identity-access-management/terraform.tfstate"
        region  = "us-east-1"
        profile = "terraform"
    }
}