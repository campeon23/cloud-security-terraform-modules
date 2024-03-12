# Create an IP Set for WAF & Shield
resource "aws_wafv2_ip_set" "blacklistips" {
  name               = "blacklistips"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = [""] # Replace with your actual public IP
}

# Create a Web ACL
resource "aws_wafv2_web_acl" "ecc_web_acl" {
  name        = "ecc-web-acl"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ecc_web_acl"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "Rule1"
    priority = 1

    action {
      block {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Rule1"
      sampled_requests_enabled   = true
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blacklistips.arn
      }
    }
  }
  tags = {
    Name = "ecc-web-acl"
    Department = "Training"
    Environment = "Development"
  }
}

# Assuming you have a WAF Web ACL defined (placeholder example)
resource "aws_wafv2_web_acl_association" "ecc_web_acl" {
  resource_arn = "arn:aws:apigateway:${var.AWS_REGION}::/restapis/${aws_api_gateway_rest_api.ecc_cloud_api.id}/stages/${aws_api_gateway_stage.ecc_cloud_api_key.stage_name}"
  web_acl_arn  = aws_wafv2_web_acl.ecc_web_acl.arn
}