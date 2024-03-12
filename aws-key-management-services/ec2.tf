# EC2 volume creation with encryption using the KMS key
resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 5
  type              = "gp2"

  kms_key_id = aws_kms_key.ccse_user_master_key.arn
  encrypted  = true
}