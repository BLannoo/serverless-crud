resource "aws_api_gateway_method" "rest_method" {
  rest_api_id = var.api-gateway-id
  resource_id = var.api-gateway-resource-id
  http_method = var.rest-method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "couple_api_and_lambda" {
  http_method = aws_api_gateway_method.rest_method.http_method
  integration_http_method = "POST"
  resource_id = var.api-gateway-resource-id
  rest_api_id = var.api-gateway-id
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda.invoke_arn
}

resource "aws_lambda_permission" "api_lambda_permission" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${var.api-gateway-execution-arn}/*/*"
}

output "api-lambda-coupling" {
  value = aws_api_gateway_integration.couple_api_and_lambda
}