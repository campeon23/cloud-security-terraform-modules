resource "aws_s3_bucket" "department_info" {
  bucket = "department-info-1"
  
  # Retain the default tags (This is typically handled by a Terraform provider default_tags configuration)
  # Here is an example, modify according to your actual tagging strategy
  tags = {
    "Name" = "DepartmentInfo"
    "Environment" = "Production"
    "ManagedBy" = "Terraform"
  }
}

resource "aws_s3_bucket_ownership_controls" "department_info" {
  bucket = aws_s3_bucket.department_info.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


# Enable S3 bucket ownership controls
resource "aws_s3_bucket_public_access_block" "department_info" {
  bucket = aws_s3_bucket.department_info.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "department_info" {
  depends_on = [
    aws_s3_bucket_ownership_controls.department_info,
    aws_s3_bucket_public_access_block.department_info,
  ]

  bucket = aws_s3_bucket.department_info.id
  acl    = "private"
}

# Versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_department_info_s3" {
  bucket = aws_s3_bucket.department_info.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "department_info" {
  bucket = aws_s3_bucket.department_info.id
  rule {
    apply_server_side_encryption_by_default {
     sse_algorithm = "AES256"
    }
  }
}

# S3 bucket for access logging
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "wildb-access-logs"

  tags = {
    "Name"        = "wildb-access-logs"
    "Environment" = "Production"
    "ManagedBy"   = "Terraform"
  }
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

resource "aws_s3_bucket_logging" "department_info" {
  bucket = aws_s3_bucket.department_info.id

  target_bucket = aws_s3_bucket.logging_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_object" "index_html" {
  bucket    = aws_s3_bucket.department_info.id
  key       = "index.html"
  source    = "./data/index.html"
  # The following line is to force the upload of the file upon changes
  etag = filemd5("./data/index.html")

  # Enable server-side encryption
  server_side_encryption = "AES256"

  # Add additional tags as per best practices
  tags = {
    "Name"        = "DepartmentInfoIndexHtml"
    "Environment" = "Production"
    "ManagedBy"   = "Terraform"
    "Department"  = "Information Security"
  }
}

# Bucket policy to be updated to grant read access to the OAI
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.department_info.bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.department_info.bucket}/*"
        Principal = { AWS = aws_cloudfront_origin_access_identity.oai.iam_arn }
        Condition = {
          Bool = {
            "aws:SecureTransport": "true"
          }
        }
      },
    ]
  })
}