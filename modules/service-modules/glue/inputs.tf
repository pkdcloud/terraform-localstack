# inputs.tf

variable "database_name" {
  description = "(Required) Name of the database. The acceptable characters are lowercase letters, numbers, and the underscore character."
  type        = string
}
