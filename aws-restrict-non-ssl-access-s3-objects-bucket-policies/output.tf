output "bucket_name" {
  value = aws_s3_bucket.training_group.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.training_group.arn
}

output "webapp_url" {
  value = "https://${aws_s3_bucket.training_group.bucket}.s3.${var.AWS_REGION}.amazonaws.com/${aws_s3_object.webapp.key}"
}