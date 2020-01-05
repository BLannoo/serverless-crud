data "archive_file" "lambda_zip" {
  type = "zip"
  output_path = "/tmp/${var.src-filename}.zip"
  source {
    content = file("resources/${var.src-filename}.py")
    filename = "${var.src-filename}.py"
  }
}

resource "aws_lambda_function" "lambda" {
  filename = data.archive_file.lambda_zip.output_path
  function_name = "terraform-${var.src-filename}"
  role = var.lambda-role-arn
  handler = "${var.src-filename}.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime = "python3.8"
  environment {
    variables = {
      tableName = var.project-name
    }
  }
}