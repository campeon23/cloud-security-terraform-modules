resource "aws_lambda_function" "lambda_authorizer" {
  function_name = "lambda_authorizer"
  description   = "Lambda function for API Gateway authorizer"
  handler       = "index.handler" # Update with your handler location
  role          = aws_iam_role.lambda_authorizer_role.arn
  runtime       = "nodejs18.x"   # Update with your lambda's runtime

  # Assuming your Lambda function code is in a file called 'lambda_function.zip'
  filename         = "./nodejs/lambda_function.zip"
  source_code_hash = filebase64sha256("./nodejs/lambda_function.zip")

#   # Set environment variables if needed
#   environment {
#     variables = {
#       EXAMPLE_VAR = "example_value"
#     }
#   }

  # If your Lambda function needs to access VPC resources
  # vpc_config {
  #   subnet_ids         = [aws_subnet.example.id]
  #   security_group_ids = [aws_security_group.example.id]
  # }

  tags = {
    Name = "LambdaAuthorizer"
    Department = "Training"
    Environment = "Development"
  }
}