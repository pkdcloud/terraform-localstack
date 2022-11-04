# inputs.tf

variable "name" {
  description = "(Optional) The name of the topic. Topic names must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 256 characters long. For a FIFO (first-in-first-out) topic, the name must end with the .fifo suffix. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "(Optional) Creates a unique name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "display_name" {
  description = "(Optional) The display name for the topic"
  type        = string
  default     = "null"
}

variable "fifo_topic" {
  description = "(Optional) Boolean indicating whether or not to create a FIFO (first-in-first-out) topic."
  type        = bool
  default     = false
}

variable "topic_subscription" {
  description = "(Optional) Configuration for a topic subscription. (Required) Protocol to use. Valid values are: sqs, sms, lambda, firehose, and application. Protocols email, email-json, http and https are also valid but partially supported. (Required) Endpoint to send data to. The contents vary with the protocol. (Raw Message Delivery Optional)"
  type = map(object({
    endpoint             = string
    protocol             = string
    raw_message_delivery = optional(bool)
  }))
  default = {}
}
