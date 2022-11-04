# inputs.tf

variable "name" {
  description = "(Optional) The name of the queue. Queue names must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 80 characters long. For a FIFO (first-in-first-out) queue, the name must end with the .fifo suffix. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "(Optional) Creates a unique name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "fifo_queue" {
  description = "(Optional) Boolean indicating whether or not to create a FIFO (first-in-first-out) queue."
  type        = bool
  default     = false
}