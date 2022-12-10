# inputs.tf

variable "function_name" {
  description = "(Required) Unique name for your Lambda Function."
  type        = string
}

variable "role" {
  description = "(Required) Amazon Resource Name (ARN) of the function's execution role. The role provides the function's identity and access to AWS services and resources."
  type        = string
}

variable "handler" {
  description = "(Optional) Function entrypoint in your code."
  type        = optional(string)
  default     = null
}

variable "filename" {
  description = "(Optional) Path to the function's deployment package within the local filesystem. Conflicts with image_uri, s3_bucket, s3_key, and s3_object_version."
  type        = optional(string)
  default     = null
}

variable "runtime" {
  description = "(Optional) Identifier of the function's runtime. See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime for valid values."
  type        = optional(string)
  default     = null
}

variable "package_type" {
  description = "(Optional) Lambda deployment package type. Valid values are Zip and Image. Defaults to Zip."
  type        = optional(string)
  default     = null
}

variable "environment" {
  type        = optional(map(any))
  description = "(Optional) Map of environment variables that are accessible from the function code during execution."
  default     = null
}

variable "sqs_event_source_mapping" {
  description = "(Optional) Configuration for a sqs event source triggers. (Required) The event source ARN."
  type = map(object({
    event_source_arn = optional(string)
  }))
  default = null
}
