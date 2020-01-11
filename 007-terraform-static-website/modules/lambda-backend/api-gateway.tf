resource "aws_api_gateway_resource" "rest_path" {
  parent_id = var.api_gateway_root
  path_part = var.src_filename
  rest_api_id = var.api_gateway_id
}

resource "aws_api_gateway_method" "rest_method" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.rest_path.id
  http_method = var.rest_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_and_lambda_integration" {
  http_method = aws_api_gateway_method.rest_method.http_method
  integration_http_method = "POST"
  resource_id = aws_api_gateway_resource.rest_path.id
  rest_api_id = var.api_gateway_id
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda.invoke_arn
}

resource "aws_lambda_permission" "api_lambda_permission" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${var.api_gateway_execution_arn}/*/*"
}

output "api_lambda_integration" {
  value = aws_api_gateway_integration.api_and_lambda_integration
}