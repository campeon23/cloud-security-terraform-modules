# IAM user creation with login profile and access keys
resource "aws_iam_user" "alice" {
  name = "Alice"
  force_destroy = true
  tags = {
    Name        = "Alice" 
    Department  = "Training"
  }
}
