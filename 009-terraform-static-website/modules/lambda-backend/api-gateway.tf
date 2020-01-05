resource "aws_api_gateway_rest_api" "api" {
  name = "${var.project-name}-api-gateway"
}

resource "aws_api_gateway_resource" "tasks_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "tasks"
}

resource "aws_api_gateway_method" "rest_method_get_all_tasks" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.tasks_resource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "couple_api_and_lambda_get_all_tasks" {
  http_method = aws_api_gateway_method.rest_method_get_all_tasks.http_method
  integration_http_method = "POST"
  resource_id = aws_api_gateway_resource.tasks_resource.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  type = "AWS_PROXY"
  uri = aws_lambda_function.get_all_tasks_lambda.invoke_arn
}

resource "aws_lambda_permission" "api_lambda_permission" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_all_tasks_lambda.function_name
  principal = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deploying_api_gateway" {
  depends_on = [
    aws_api_gateway_integration.couple_api_and_lambda_get_all_tasks
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = "default"
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api.id
}