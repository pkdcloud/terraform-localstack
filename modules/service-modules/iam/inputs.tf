# inputs.tf

variable "assume_role_policy" {
  description = "(Required) Policy that grants an entity permission to assume the role."
  type        = string
}

variable "policy" {
  description = "(Required) The policy document. This is a JSON formatted string."
  type        = string
  default     = null
}

variable "name" {
  description = " (Optional), Forces new resource) Friendly name of the role. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}
