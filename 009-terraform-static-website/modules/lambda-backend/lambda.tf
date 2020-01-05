data "archive_file" "lambda_zip" {
  type = "zip"
  output_path = "/tmp/get-all-tasks-serverless-task-list.zip"
  source {
    content = file("resources/get-all-tasks-serverless-task-list.py")
    filename = "get-all-tasks-serverless-task-list.py"
  }
}

resource "aws_lambda_function" "get_all_tasks_lambda" {
  filename = data.archive_file.lambda_zip.output_path
  function_name = "terraform-get-all-tasks-serverless-task-list"
  role = aws_iam_role.lambda-role.arn
  handler = "get-all-tasks-serverless-task-list.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime = "python3.8"
  environment {
    variables = {
      tableName = var.project-name
    }
  }
}