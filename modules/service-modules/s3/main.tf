# main.tf

resource "aws_s3_bucket" "this" {
  bucket = var.bucket

  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.acl
}