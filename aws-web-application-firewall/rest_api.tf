# Create a REST API via API Gateway
resource "aws_api_gateway_rest_api" "ecc_cloud_api" {
  name        = "ecc-cloud-api"
  description = "This is a REST API"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  minimum_compression_size = 1024 # Set a valid compression size between 0 and 10485760 bytes

  tags = {
    Name        = "ecc-cloud-api"
    Environment = "dev" # Example tag, add more as necessary
  }
}

# Placeholder for the authorizer - implement according to your auth strategy
resource "aws_api_gateway_authorizer" "ecc_cloud_api_authorizer" {
  name          = "ecc_cloud_api_authorizer"
  type          = "TOKEN" # Or other types like REQUEST, COGNITO_USER_POOLS, etc.
  rest_api_id   = aws_api_gateway_rest_api.ecc_cloud_api.id
  identity_source = "method.request.header.Authorization" # Example value
  authorizer_uri          = aws_lambda_function.lambda_authorizer.invoke_arn
  authorizer_credentials  = aws_iam_role.lambda_authorizer_role.arn

  # If you are using a Lambda function, provide the ARN of the function
  # You also need to ensure that execution permissions are granted to API Gateway to invoke the Lambda
}

resource "aws_api_gateway_api_key" "ecc_cloud_api_key" {
  name = "ecc-cloud-api-key"
  description = "API key for a REST API"
  enabled = true
}

resource "aws_api_gateway_usage_plan" "ecc_cloud_api_key" {
  name = "ecc-cloud-usage-plan"
  description = "Usage plan for a REST API"
  
  api_stages {
    api_id = aws_api_gateway_rest_api.ecc_cloud_api.id
    stage = aws_api_gateway_stage.ecc_cloud_api_key.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "ecc_cloud_api_key" {
  key_id = aws_api_gateway_api_key.ecc_cloud_api_key.id
  key_type = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.ecc_cloud_api_key.id
}

# Define the stage resource if you haven't already
resource "aws_api_gateway_stage" "ecc_cloud_api_key" {
  stage_name    = "ecc-cloud-gateway-stage"
  rest_api_id   = aws_api_gateway_rest_api.ecc_cloud_api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  client_certificate_id = aws_api_gateway_client_certificate.ecc_cloud_api_client_certificate.id

  xray_tracing_enabled = true  # Enable X-Ray Tracing

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_log_group.arn
    format          = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"caller\":\"$context.identity.caller\",\"user\":\"$context.identity.user\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\",\"status\":\"$context.status\",\"protocol\":\"$context.protocol\",\"responseLength\":\"$context.responseLength\"}"
  }
}

# SSL Client Certificate (placeholder, assuming you have one created)
resource "aws_api_gateway_client_certificate" "ecc_cloud_api_client_certificate" {
  description = "example client certificate"

  tags = {
    Name = "ecc-cloud-api-client-certificate"
    Department = "Training"
    Environment = "Development"
  }
}

# Create a resource for the REST API
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.ecc_cloud_api.id
  parent_id   = aws_api_gateway_rest_api.ecc_cloud_api.root_resource_id
  path_part   = "myresource"
}

# Create a GET method on the new resource
resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.ecc_cloud_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true  # This line requires an API key for the method
}

# Set up the mock integration
resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id = aws_api_gateway_rest_api.ecc_cloud_api.id
  resource_id = aws_api_gateway_method.api_method.resource_id
  http_method = aws_api_gateway_method.api_method.http_method
  type        = "MOCK"
}

# Set up the integration response
resource "aws_api_gateway_integration_response" "api_integration_response" {
  depends_on  = [aws_api_gateway_integration.api_integration]
  rest_api_id = aws_api_gateway_rest_api.ecc_cloud_api.id
  resource_id = aws_api_gateway_method.api_method.resource_id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = "200"

  response_templates = {
    "application/json" = "{\"message\":\"This is ECC Cloud Demo api....!\"}"
  }
}

# Deploy the API
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.api_integration,
    aws_api_gateway_integration_response.api_integration_response
  ]
  
  rest_api_id = aws_api_gateway_rest_api.ecc_cloud_api.id
  stage_name  = "test"
}
