# Amazon Redshift Serverless cluster creation with encryption using the KMS key
resource "aws_redshiftserverless_namespace" "ccse_redshit_cluster" {
  namespace_name       = "redshift-cluster-1"
  admin_username       = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["username"] # username
  admin_user_password  = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["password"] # password
  db_name              = "CCSEdb"
  kms_key_id           = aws_kms_key.ccse_user_master_key.arn
}