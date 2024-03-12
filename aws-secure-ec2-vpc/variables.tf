variable "AWS_REGION" {
    type        = string
    description = "Region where the resources will be created"
    default     = "us-east-1"
}

variable "AWS_PROFILE" {
    type        = string
    description = "AWS profile to be used"
    default     = "terraform"
  
}