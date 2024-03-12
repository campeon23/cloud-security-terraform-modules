resource "aws_s3_bucket" "training_group" {
  bucket = "training-group-009"

  tags = {
    Name = "training-group-009"
    Environment = "dev"
    ManagedBy = "Terraform"
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

resource "aws_s3_object" "webapp" {
  bucket = aws_s3_bucket.training_group.bucket
  key    = "WebApp.html"
  source = "./data/WebApp.html"
  # The following line is to force the upload of the file upon changes
  etag = filemd5("./data/WebApp.html")

  # Enable server-side encryption
  server_side_encryption = "AES256"

  acl    = "private" # Initially set to public-read to make the object publicly accessible

  # Add additional tags as per best practices
  tags = {
    "Name"        = "DepartmentInfoIndexHtml"
    "Environment" = "Production"
    "ManagedBy"   = "Terraform"
    "Department"  = "Information Security"
  }
}

resource "aws_s3_bucket_policy" "deny_non_https" {
  bucket = aws_s3_bucket.training_group.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "s3:*",
        Effect    = "Deny",
        Resource  = [ 
            "${aws_s3_bucket.training_group.arn}/*",
            aws_s3_bucket.training_group.arn
        ],
        Principal = "*",
        Condition = {
          Bool = {
            "aws:SecureTransport": "false"
          }
        }
      }
    ]
  })
}
