variable "bucket-name" {}

variable "api-gateway-id" {}

variable "index-template-location" {}

resource "aws_s3_bucket" "s3-static-bucket" {
  bucket = var.bucket-name
  acl = "public-read"
  policy = templatefile("${path.module}/public-bucket-policy.json", {
    bucket-name = var.bucket-name
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
  bucket = var.bucket-name
  key = "index.html"
  content = templatefile(var.index-template-location, {
    api-gateway-id = var.api-gateway-id
  })
  content_type = "text/html"
  etag = md5(templatefile(var.index-template-location, {
    api-gateway-id = var.api-gateway-id
  }))
}

resource "aws_s3_bucket_object" "error-file" {
  depends_on = [
    aws_s3_bucket.s3-static-bucket
  ]
  bucket = var.bucket-name
  key = "error.html"
  source = "${path.module}/error.html"
  content_type = "text/html"
  etag = filemd5("${path.module}/error.html")
}