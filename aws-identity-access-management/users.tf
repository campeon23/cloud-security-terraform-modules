# Create an IAM user name "Alice"
resource "aws_iam_user" "alice" {
  name          = "Alice"
  force_destroy = true
  tags = {
    Name        = "Alice" 
    Department  = "Training"
  }
}