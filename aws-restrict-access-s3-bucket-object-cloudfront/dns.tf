# Attempt to query the existing hosted zone
data "aws_route53_zone" "existing_ecc_cloud_zone" {
  name         = "mediterani.com"
  private_zone = false

  # This prevents Terraform from failing if the zone doesn't exist
  count = var.create_zone ? 0 : 1
}

# Create a new hosted zone if it doesn't exist
resource "aws_route53_zone" "new_ecc_cloud_zone" {
  name = "mediterani.com"

  tags = {
    "Environment" = "Production"
    "Project"     = "ECC Cloud Certification"
    "ManagedBy"   = "Terraform"
  }

  # Only create if the existing zone wasn't found
  count = var.create_zone && length(data.aws_route53_zone.existing_ecc_cloud_zone) == 0 ? 1 : 0
}

# Use the existing zone if it was found, otherwise use the new zone
locals {
  zone_id = length(data.aws_route53_zone.existing_ecc_cloud_zone) > 0 ? data.aws_route53_zone.existing_ecc_cloud_zone[0].id : aws_route53_zone.new_ecc_cloud_zone[0].id
  zone_name = length(data.aws_route53_zone.existing_ecc_cloud_zone) > 0 ? data.aws_route53_zone.existing_ecc_cloud_zone[0].name : aws_route53_zone.new_ecc_cloud_zone[0].name
}

resource "aws_route53_record" "ecc_cloud_cert_validation" {

  depends_on = [ aws_acm_certificate.ecc_cloud_cert ]

  for_each = {
    for dvo in toset(aws_acm_certificate.ecc_cloud_cert.domain_validation_options) : dvo.domain_name => {
      name    = dvo.resource_record_name
      type    = dvo.resource_record_type
      records = [dvo.resource_record_value]
    }
  }

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  records = each.value.records
  ttl     = 60
}
