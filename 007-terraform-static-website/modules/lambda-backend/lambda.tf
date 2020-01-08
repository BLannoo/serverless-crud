data "archive_file" "lambda_zip" {
  type = "zip"
  output_path = "/tmp/${var.src_filename}.zip"
  source {
    content = file("resources/${var.src_filename}.py")
    filename = "${var.src_filename}.py"
  }
}

resource "aws_lambda_function" "lambda" {
  filename = data.archive_file.lambda_zip.output_path
  function_name = "terraform-${var.src_filename}"
  role = var.lambda_role_arn
  handler = "${var.src_filename}.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime = "python3.8"
  environment {
    variables = {
      tableName = var.project_name
    }
  }
}