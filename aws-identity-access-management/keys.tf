# Create access keys for user "Alice"
resource "aws_iam_access_key" "alice_access_key" {
  user = aws_iam_user.alice.name
}