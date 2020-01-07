provider "aws" {
  version = "~> 2.43"
  region = "eu-west-1"
  profile = "personal-dev"
}

provider "archive" {
  version = "~> 1.3"
}

locals {
  project_name = "terraform-crud-experiment"
}

module "lambda_backend_skeleton" {
  source = "./modules/lambda-backend-skeleton"

  project_name = local.project_name
}

module "get_all_tasks_lambda" {
  source = "./modules/lambda-backend"

  src_filename = "get-all-tasks"
  project_name = local.project_name
  rest_method = "GET"
  lambda_role_arn = module.lambda_backend_skeleton.lambda_role_arn
  api_gateway_id = module.lambda_backend_skeleton.api_gateway_id
  api_gateway_resource_id = module.lambda_backend_skeleton.api_gateway_resource_id
  api_gateway_execution_arn = module.lambda_backend_skeleton.api_gateway_execution_arn
}

module "create_task_lambda" {
  source = "./modules/lambda-backend"

  src_filename = "create-task"
  project_name = local.project_name
  rest_method = "POST"
  lambda_role_arn = module.lambda_backend_skeleton.lambda_role_arn
  api_gateway_id = module.lambda_backend_skeleton.api_gateway_id
  api_gateway_resource_id = module.lambda_backend_skeleton.api_gateway_resource_id
  api_gateway_execution_arn = module.lambda_backend_skeleton.api_gateway_execution_arn
}

module "deleting_task_lambda" {
  source = "./modules/lambda-backend"

  src_filename = "deleting-task"
  project_name = local.project_name
  rest_method = "DELETE"
  lambda_role_arn = module.lambda_backend_skeleton.lambda_role_arn
  api_gateway_id = module.lambda_backend_skeleton.api_gateway_id
  api_gateway_resource_id = module.lambda_backend_skeleton.api_gateway_resource_id
  api_gateway_execution_arn = module.lambda_backend_skeleton.api_gateway_execution_arn
}

resource "aws_api_gateway_deployment" "deploying_api_gateway" {
  // TODO: figure out if these dependencies are enough/nescessarry
  depends_on = [
    module.get_all_tasks_lambda.api_lambda_integration,
    module.create_task_lambda.api_lambda_integration,
    module.deleting_task_lambda.api_lambda_integration,
    module.lambda_backend_skeleton.options_method_configured
  ]
  rest_api_id = module.lambda_backend_skeleton.api_gateway_id
  stage_name = "default"
}

module "s3_front_end_deploy" {
  source = "./modules/s3-frontend"

  bucket_name = "${local.project_name}-bucket"
  api_gateway_id = module.lambda_backend_skeleton.api_gateway_id
  index_template_location = "./resources/index.template.html"
}

module "dynamodb_persistence" {
  source = "./modules/dynamodb-persistence"

  project_name = local.project_name
}