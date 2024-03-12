## DB Secret
data "aws_secretsmanager_secret" "redshift_credentials" {
  name = "redshift_secret"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.redshift_credentials.id
}