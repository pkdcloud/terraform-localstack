# inputs.tf

variable "name" {
  description = "(Required) A name to identify the stream. This is unique to the AWS account and region the Stream is created in."
  type        = string
}

variable "role_arn" {
  description = "(Required) The ARN of the AWS credentials."
  type        = string
}

variable "bucket_arn" {
  description = " (Required) The ARN of the S3 bucket"
  type        = string
}
