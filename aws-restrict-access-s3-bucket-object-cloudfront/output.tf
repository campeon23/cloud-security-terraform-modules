output "distribution_url" {
    description = "The URL of the CloudFront distribution"
    value = aws_cloudfront_distribution.s3_distribution.domain_name
}