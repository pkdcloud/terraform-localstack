# inputs.tf

# -------------------------------------------------
# Lakeformation Settings Variables
# -------------------------------------------------

variable "enable_module" {
  description = "Enables the Module. Disabling tears down all module resources."
  type        = bool
  default     = false
}

variable "admins" {
  description = "(Optional) Set of ARNs of AWS Lake Formation principals (IAM users or roles)."
  type        = list(string)
  default     = null
}

variable "catalog_id" {
  description = "(Optional) Identifier for the Data Catalog. By default, the account ID."
  type        = string
  default     = null
}

variable "trusted_resource_owners" {
  description = "(Optional) List of the resource-owning account IDs that the caller's account can use to share their user access details (user ARNs)."
  type        = list(string)
  default     = null
}

variable "database_default_permissions" {
  description = "(Optional) Up to three configuration blocks of principal permissions for default create database permissions."
  type        = list(any)
  default     = []
}

variable "table_default_permissions" {
  description = "(Optional) Up to three configuration blocks of principal permissions for default create table permissions."
  type        = list(map(any))
  default     = []
}

# -------------------------------------------------
# Lakeformation Location Variables
# -------------------------------------------------

variable "locations" {
  description = "(Optional) Provides Lake Formation Data Lake Location Resources."
  type = map(object({
    arn      = string
    role_arn = string
  }))
  default = null
}
