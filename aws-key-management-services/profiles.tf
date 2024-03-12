resource "aws_iam_user_login_profile" "alice_login_profile" {
  user                      = aws_iam_user.alice.name
  password_length           = 16
  password_reset_required   = true
}