terraform {
    backend "s3" {
        bucket  = "wildb-terraform-state-bucket"
        key     = "terrafom/aws-restrict-access-s3-bucket-object-cloudfront/terraform.tfstate"
        region  = "us-east-1"
        profile = "terraform"
    }
}