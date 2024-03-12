# S3 bucket creation, enable versioning, encryption and access logging
resource "aws_s3_bucket" "training_group" {
  bucket        = "training-group-001"
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
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "training_group" {
  bucket = aws_s3_bucket.training_group.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.logging_bucket_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# S3 bucket for access logging
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "wildb-access-logs"
}

resource "aws_s3_bucket_ownership_controls" "logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


# Enable S3 bucket ownership controls
resource "aws_s3_bucket_public_access_block" "logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "logging_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.logging_bucket,
    aws_s3_bucket_public_access_block.logging_bucket,
  ]

  bucket = aws_s3_bucket.logging_bucket.id
  acl    = "private"
}

# Versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_logging_bucket_s3" {
  bucket = aws_s3_bucket.logging_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.logging_bucket_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.logging_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "training_group" {
  bucket = aws_s3_bucket.training_group.id

  target_bucket = aws_s3_bucket.logging_bucket.id
  target_prefix = "log/"
}