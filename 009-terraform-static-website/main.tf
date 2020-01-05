provider "aws" {
  version = "~> 2.43"
  region = "eu-west-1"
  profile = "personal-dev"
}

provider "archive" {
  version = "~> 1.3"
}

locals {
  project-name = "terraform-crud-experiment"
}

module "lambda-backend-skeleton" {
  source = "./modules/lambda-backend-skeleton"

  project-name = local.project-name
}

module "get_all_tasks_lambda" {
  source = "./modules/lambda-backend"

  src-filename = "get-all-tasks-serverless-task-list"
  project-name = local.project-name
  rest-method = "GET"
  lambda-role-arn = module.lambda-backend-skeleton.lambda-role-arn
  api-gateway-id = module.lambda-backend-skeleton.api_gateway_id
  api-gateway-resource-id = module.lambda-backend-skeleton.api_gateway_resource_id
  api-gateway-execution-arn = module.lambda-backend-skeleton.api_gateway_execution_arn
}

resource "aws_api_gateway_deployment" "deploying_api_gateway" {
  depends_on = [
    module.get_all_tasks_lambda.api-lambda-coupling
  ]
  rest_api_id = module.lambda-backend-skeleton.api_gateway_id
  stage_name = "default"
}

module "s3-front-end-deploy" {
  source = "./modules/s3-frontend"

  bucket-name = "${local.project-name}-bucket"
  api-gateway-id = module.lambda-backend-skeleton.api_gateway_id
  index-template-location = "./resources/index.html.template"
}

module "dynamodb-persistence" {
  source = "./modules/dynamodb-persistence"

  project-name = local.project-name
}