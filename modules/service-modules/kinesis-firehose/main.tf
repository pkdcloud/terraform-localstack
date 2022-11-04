# main.tf

resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = var.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = var.role_arn
    bucket_arn = var.bucket_arn
  }
}
