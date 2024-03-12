output "alice_password" {
    description = "The encrypted password for the IAM user Alice's login profile."
    value = aws_iam_user_login_profile.alice_login_profile.encrypted_password
}