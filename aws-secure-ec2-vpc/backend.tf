terraform {
    backend "s3" {
        bucket  = "wildb-terraform-state-bucket"
        key     = "terrafom/aws-secure-ec2-vpc/terraform.tfstate"
        region  = "us-east-1"
        profile = "terraform"
    }
}