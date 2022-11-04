# inputs.tf

variable "bucket" {
  description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length. A full list of bucket naming rules may be found https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html."
  type        = string
  default     = null
}

variable "acl" {
  description = "(Optional, Deprecated) The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write. Defaults to private. Conflicts with grant. Terraform will only perform drift detection if a configuration value is provided. Use the resource aws_s3_bucket_acl instead."
  type        = string
  default     = "private"
}

variable "force_destroy" {
  description = "(Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}