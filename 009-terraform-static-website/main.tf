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

module "get_all_tasks_lambda" {
  source = "./modules/lambda-backend"

  project-name = local.project-name
}

module "s3-front-end-deploy" {
  source = "./modules/s3-frontend"

  bucket-name = "${local.project-name}-bucket"
  api-gateway-id = module.get_all_tasks_lambda.api_gateway_id
  index-template-location = "./resources/index.html.template"
}