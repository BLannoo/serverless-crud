variable "bucket_name" {}

variable "api_gateway_id" {}

variable "index_template_location" {}

resource "aws_s3_bucket" "s3-static-bucket" {
  bucket = var.bucket_name
  acl = "public-read"
  policy = templatefile("${path.module}/public-bucket-policy.json", {
    bucket-name = var.bucket_name
  })
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "index-file" {
  depends_on = [
    aws_s3_bucket.s3-static-bucket
  ]
  bucket = var.bucket_name
  key = "index.html"
  content = templatefile(var.index_template_location, {
    api-gateway-id = var.api_gateway_id
  })
  content_type = "text/html"
  etag = md5(templatefile(var.index_template_location, {
    api-gateway-id = var.api_gateway_id
  }))
}

resource "aws_s3_bucket_object" "error-file" {
  depends_on = [
    aws_s3_bucket.s3-static-bucket
  ]
  bucket = var.bucket_name
  key = "error.html"
  source = "${path.module}/error.html"
  content_type = "text/html"
  etag = filemd5("${path.module}/error.html")
}