resource "aws_api_gateway_rest_api" "api" {
  name = "${var.project_name}-api-gateway"
}

resource "aws_api_gateway_resource" "tasks_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "tasks"
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