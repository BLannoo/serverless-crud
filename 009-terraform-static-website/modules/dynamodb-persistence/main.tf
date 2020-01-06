variable "project_name" {}

resource "aws_dynamodb_table" "db" {
  name = var.project_name
  read_capacity = 5
  write_capacity = 5
  hash_key = "PK"
  attribute {
    name = "PK"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "example_1" {
  table_name = aws_dynamodb_table.db.name
  hash_key = aws_dynamodb_table.db.hash_key

  item = <<ITEM
{
  "PK": {"S": "TASK#32cbf8c5-f080-45f6-a616-e84b40c54c4c"},
  "description": {"S": "Pay Bills"},
  "isCompleted": {"BOOL": false}
}
ITEM
}

resource "aws_dynamodb_table_item" "example_2" {
  table_name = aws_dynamodb_table.db.name
  hash_key = aws_dynamodb_table.db.hash_key

  item = <<ITEM
{
  "PK": {"S": "TASK#de8bf42a-1b6d-494a-ac4b-ebe0225a5774"},
  "description": {"S": "Go Shopping"},
  "isCompleted": {"BOOL": false}
}
ITEM
}

resource "aws_dynamodb_table_item" "example_3" {
  table_name = aws_dynamodb_table.db.name
  hash_key = aws_dynamodb_table.db.hash_key

  item = <<ITEM
{
  "PK": {"S": "TASK#7aac9f6e-b959-4766-8ae1-c35d46ad956c"},
  "description": {"S": "See the Doctor"},
  "isCompleted": {"BOOL": true}
}
ITEM
}