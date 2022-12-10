# inputs.tf

variable "name" {
  description = "(Optional) The display name of the alias. The name must start with the word 'alias' followed by a forward slash (alias/)"
  type        = string
  default     = ""
}

variable "target_key_id" {
  description = "(Required) Identifier for the key for which the alias is for, can be either an ARN or key_id."
  type        = string
  default     = null
}
