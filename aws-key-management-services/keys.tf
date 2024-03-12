resource "aws_iam_access_key" "alice" {
  user    = aws_iam_user.alice.name
}

# KMS key creation with alias and administrative permissions for the user
resource "aws_kms_key" "ccse_user_master_key" {
  description             = "The key is used to protect the files for the Training Group."
  deletion_window_in_days = 7
  enable_key_rotation     = true  # Enable rotation of the KMS key
  key_usage               = "ENCRYPT_DECRYPT"
  is_enabled              = true

  policy = jsonencode({
    Version = "2012-10-17",
    Id = "key-default-1",
    Statement = [
      {
        Sid = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"},
        Action = "kms:*",
        Resource = "*"
      },
      {
        Sid = "Allow full access to key management for Alice",
        Effect = "Allow",
        Principal = {"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Alice"},
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource = "*"
      },
      {
        Sid = "Allow use of the key for encryption and decryption",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Alice"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:GenerateDataKeyWithoutPlaintext"
        ],
        Resource = "*"
      }
    ]
  })

  tags = {
    CCSEUserKey = "training"
  }
}

resource "aws_kms_alias" "ccse_user_master_key_alias" {
  name          = "alias/CCSE_user_MasterKey"
  target_key_id = aws_kms_key.ccse_user_master_key.key_id
}

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
        {
        "Sid": "Allow use of the key",
        "Effect": "Allow",
        "Principal": {"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Alice"},
        "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
        ],
        "Resource": "*"
        },
        {
        "Sid": "Allow attachment of persistent resources",
        "Effect": "Allow",
        "Principal": {"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Alice"},
        "Action": [
            "kms:CreateGrant",
            "kms:ListGrants",
            "kms:RevokeGrant"
        ],
        "Resource": "*",
        "Condition": {"Bool": {"kms:GrantIsForAWSResource": "true"}}
        }
    ]
    })
}

resource "aws_kms_alias" "logging_bucket_key_alias" {
  name          = "alias/logging_bucket_MasterKey"
  target_key_id = aws_kms_key.logging_bucket_key.key_id
}

# Data source to get the account ID of the caller
data "aws_caller_identity" "current" {}

