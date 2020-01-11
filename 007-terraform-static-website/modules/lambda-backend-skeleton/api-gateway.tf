resource "aws_api_gateway_rest_api" "api" {
  name = "${var.project_name}-api-gateway"
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "api_gateway_root" {
  value = aws_api_gateway_rest_api.api.root_resource_id
}