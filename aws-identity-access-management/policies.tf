# Attach te "IAMUserChangePassword" policy to the "Traninig_Group"
resource "aws_iam_group_policy_attachment" "change_password" {
  group      = aws_iam_group.training_group.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

# Attach the "DatabaseAdministrator" managed policy to the "Traning_Group"
resource "aws_iam_group_policy_attachment" "db_administrator" {
  group      = aws_iam_group.training_group.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
}

# Attach existing policy "AmazonS3ReadOnlyAccess" to the "Training_Group"
resource "aws_iam_group_policy_attachment" "training_group_s3_read_only" {
  group      = aws_iam_group.training_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Create a custom policy for CloudFront read access requiring MFA
resource "aws_iam_policy" "user_access_custom_policy" {
  name        = "UserAccessCustomPolicy"
  description = "Allow users to access CloudFront read only with MFA"

  # Policy definition document in JSON
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontAccessWithMFA"
        Effect = "Allow"
        Action = "cloudfront:Get*"
        Resource = "*"
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })

  # Adding tags
  tags = {
    Purpose = "AccessControl"
    ManagedBy = "Terraform"
  }
}

# Attach the custom policy to the "Traning_Group"
resource "aws_iam_group_policy_attachment" "custom_policy_attachment" {
  group      = aws_iam_group.training_group.name
  policy_arn = aws_iam_policy.user_access_custom_policy.arn
}