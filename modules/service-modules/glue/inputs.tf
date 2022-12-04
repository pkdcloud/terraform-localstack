# inputs.tf

# -------------------------------------------------
# Glue Database Variables
# -------------------------------------------------

variable "enable_module" {
  description = "Enables the Module. Disabling tears down all resources."
  type        = bool
  default     = false
}

variable "catalog_id" {
  description = "(Optional) Identifier for the Data Catalog. By default, the account ID."
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional) Description of the database."
  type        = string
  default     = null
}

variable "location_uri" {
  description = "(Optional) Location of the database (for example, an HDFS path)."
  type        = string
  default     = null
}

variable "name" {
  description = "(Required) Name of the database. The acceptable characters are lowercase letters, numbers, and the underscore character."
  type        = string
}

variable "parameters" {
  description = "(Optional) List of key-value pairs that define parameters and properties of the database."
  type        = map(string)
  default     = null
}

# -------------------------------------------------
# Glue Table Variables
# -------------------------------------------------

variable "tables" {
  description = "(Optional) Provides Glue Catalog Table Resources."
  type = map(object({
    database_name = string
    description   = optional(string)
    storage_descriptor = optional(object({
      location = optional(string)
    }))
  }))
  default = null
}
