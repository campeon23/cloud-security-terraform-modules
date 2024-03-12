# Output the invoke URL of the deployed API
output "invoke_url" {
  description = "value of the invoke URL for the deployed API"
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}

output "api_key" {
  description = "The value of the API key for the REST API"
  value = aws_api_gateway_api_key.ecc_cloud_api_key.value
  sensitive = true
}

