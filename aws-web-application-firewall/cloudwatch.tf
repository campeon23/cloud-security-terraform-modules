resource "aws_cloudwatch_log_group" "api_gw_log_group" {
  name = "/aws/api_gateway/ecc_cloud_api_gw_logs"

  retention_in_days = 90
}