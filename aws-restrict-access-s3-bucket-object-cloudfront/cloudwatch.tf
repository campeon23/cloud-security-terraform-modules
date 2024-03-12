resource "aws_cloudwatch_log_group" "route53_log_group" {
  name              = "/aws/route53/${local.zone_name}"
  retention_in_days = 1 # Set the retention period as needed
}

resource "aws_route53_query_log" "ecc_cloud_cert_query_log" {
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53_log_group.arn
  zone_id                  = local.zone_id
}

resource "aws_cloudwatch_log_resource_policy" "route53_query_logging_policy" {
  policy_name     = "Route53QueryLoggingPolicy"
  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "route53.amazonaws.com" },
        Action    = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource  = "${aws_cloudwatch_log_group.route53_log_group.arn}:*"
      },
    ]
  })
}
