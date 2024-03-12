resource "aws_s3_bucket" "training_group" {
  bucket = "training-group-002"
  tags = {
    Name        = "training-group-002"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_ownership_controls" "training_group" {
  bucket = aws_s3_bucket.training_group.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


# Enable S3 bucket ownership controls
resource "aws_s3_bucket_public_access_block" "training_group" {
  bucket = aws_s3_bucket.training_group.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "training_group" {
  depends_on = [
    aws_s3_bucket_ownership_controls.training_group,
    aws_s3_bucket_public_access_block.training_group,
  ]

  bucket = aws_s3_bucket.training_group.id
  acl    = "private"
}

# Versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_training_group_s3" {
  bucket = aws_s3_bucket.training_group.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "training_group" {
  bucket = aws_s3_bucket.training_group.id
  rule {
    apply_server_side_encryption_by_default {
     sse_algorithm = "AES256"
    }
  }
}

// The following is a placeholder for the bucket policy. You will need to
resource "aws_s3_bucket_policy" "training_group_policy" {
  bucket = aws_s3_bucket.training_group.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          ]
        },
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource": "${aws_s3_bucket.training_group.arn}/*"
      }
    ]
  })
}

# Data source to get the account ID of the caller
data "aws_caller_identity" "current" {}

