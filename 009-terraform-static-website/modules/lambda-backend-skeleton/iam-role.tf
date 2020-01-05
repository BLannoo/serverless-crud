resource "aws_iam_role" "lambda-role" {
  name = "${var.project-name}-lambda-role"

  assume_role_policy = file("${path.module}/AssumeRolePolicy.json")
}

resource "aws_iam_policy" "lambda-policy" {
  name = "${var.project-name}-lambda-policy"
  description = "A policy similar too Simple-microservice-permissions"

  policy = file("${path.module}/SimpleMicroservicePolicy.json")
}

resource "aws_iam_role_policy_attachment" "attach-lambda-role-and-policy" {
  role = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.lambda-policy.arn
}

output "lambda-role-arn" {
  value = aws_iam_role.lambda-role.arn
}