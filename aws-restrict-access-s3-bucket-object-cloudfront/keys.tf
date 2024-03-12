# Enabling encryption for the S3 bucket
resource "aws_kms_key" "logging_bucket_key" {
  description             = "This key is used to encrypt buckets objects"
  enable_key_rotation     = true  # Enable rotation of the KMS key
  deletion_window_in_days = 7

  tags = {
    Purpose = "Encrypt S3 Bucket"
    Environment = "Production" 
  }

  # Define a restrictive policy for the KMS key
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": {"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"},
        "Action": "kms:*",
        "Resource": "*"
        },
    ]
    })
}

resource "aws_kms_alias" "logging_bucket_key_alias" {
  name          = "alias/logging_bucket_MasterKey"
  target_key_id = aws_kms_key.logging_bucket_key.key_id
}


# Data source to get the account ID of the caller
data "aws_caller_identity" "current" {}