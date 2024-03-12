variable "AWS_REGION" {
    description = "Region where the resources will be created"
    type        = string
    default     = "us-east-1"
}

variable "AWS_PROFILE" {
    description = "AWS profile to be used"
    type        = string
    default     = "terraform"
  
}

variable "create_zone" {
  description = "A boolean flag to indicate whether to create a new zone if it doesn't exist"
  type        = bool
  default     = false  # Set the default value as needed
}