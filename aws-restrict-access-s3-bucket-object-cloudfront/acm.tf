resource "aws_acm_certificate" "ecc_cloud_cert" {
  domain_name       = "*.mediterani.com" # Replace with your domain name
  validation_method = "DNS"

  tags = {
    Environment = "Production"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "ecc_cloud_cert" {
  certificate_arn         = aws_acm_certificate.ecc_cloud_cert.arn
  validation_record_fqdns = [for _, record in aws_route53_record.ecc_cloud_cert_validation : record.fqdn]
}