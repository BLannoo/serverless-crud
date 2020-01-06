resource "aws_api_gateway_rest_api" "api" {
  name = "${var.project-name}-api-gateway"
}

resource "aws_api_gateway_resource" "tasks_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "tasks"
}

resource "aws_api_gateway_method" "options_pre_flight" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.tasks_resource.id
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_mock_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.tasks_resource.id
  http_method = aws_api_gateway_method.options_pre_flight.http_method
  type = "MOCK"
  request_templates = {
    "application/json": jsonencode( {
      statusCode = 200
    } )
  }
}

resource "aws_api_gateway_method_response" "options_mock_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.tasks_resource.id
  http_method = aws_api_gateway_method.options_pre_flight.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin": false,
    "method.response.header.Access-Control-Allow-Methods": false,
    "method.response.header.Access-Control-Allow-Headers": false
  }
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "options_mock_integration" {
  // TODO: investigate which dependencies are really nescessary
  //  (used also to force all those steps to be run before the deployment)
  depends_on = [
    aws_api_gateway_method.options_pre_flight,
    aws_api_gateway_integration.options_mock_integration,
    aws_api_gateway_method_response.options_mock_response
  ]
  http_method = "OPTIONS"
  resource_id = aws_api_gateway_resource.tasks_resource.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers": "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods": "'DELETE,GET,OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin": "'*'"
  }
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "api_gateway_resource_id" {
  value = aws_api_gateway_resource.tasks_resource.id
}

output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "options_method_configured" {
  value = aws_api_gateway_integration_response.options_mock_integration
}