# inputs.tf

# -------------------------------------------------
# Lakeformation Settings Variables
# -------------------------------------------------

variable "enable_module" {
  description = "Enables the Module. Disabling tears down all module resources."
  type        = optional(bool)
  default     = true
}

variable "admins" {
  description = "(Optional) Set of ARNs of AWS Lake Formation principals (IAM users or roles)."
  type        = optional(list(string))
  default     = null
}

variable "catalog_id" {
  description = "(Optional) Identifier for the Data Catalog. By default, the account ID."
  type        = optional(string)
  default     = null
}

variable "trusted_resource_owners" {
  description = "(Optional) List of the resource-owning account IDs that the caller's account can use to share their user access details (user ARNs)."
  type        = optional(list(string))
  default     = null
}

variable "database_default_permissions" {
  description = "(Optional) Up to three configuration blocks of principal permissions for default create database permissions."
  type        = optional(list(any))
  default     = null
}

variable "table_default_permissions" {
  description = "(Optional) Up to three configuration blocks of principal permissions for default create table permissions."
  type        = optional(list(map(any)))
  default     = null
}

# -------------------------------------------------
# Lakeformation Location Variables
# -------------------------------------------------

variable "locations" {
  description = "(Optional) Provides Lake Formation Data Lake Location Resources."
  type = map(object({
    arn      = optional(string)
    role_arn = optional(string)
  }))
  default = null
}
