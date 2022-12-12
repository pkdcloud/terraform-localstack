# inputs.tf

# -------------------------------------------------
# Lakeformation Data Lake Settings Variables
# -------------------------------------------------

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

variable "create_database_default_permissions" {
  description = "(Optional) Up to three configuration blocks of principal permissions for default create database permissions."

  type = object({
    permissions = optional(string) # (Optional) List of permissions that are granted to the principal. Valid values may include ALL, SELECT, ALTER, DROP, DELETE, INSERT, DESCRIBE, and CREATE_TABLE.
    principal   = optional(string) # (Optional) Principal who is granted permissions. To enforce metadata and underlying data access control only by IAM on new databases and tables set principal to IAM_ALLOWED_PRINCIPALS and permissions to ["ALL"].
  })

  default = null
}

variable "create_table_default_permissions" {
  description = "(Optional) Up to three configuration blocks of principal permissions for default create table permissions."

  type = object({
    permissions = optional(string) # (Optional) List of permissions that are granted to the principal. Valid values may include ALL, SELECT, ALTER, DROP, DELETE, INSERT, DESCRIBE, and CREATE_TABLE.
    principal   = optional(string) # (Optional) Principal who is granted permissions. To enforce metadata and underlying data access control only by IAM on new databases and tables set principal to IAM_ALLOWED_PRINCIPALS and permissions to ["ALL"].
  })

  default = null
}

# -------------------------------------------------
# Lakeformation Location Variables
# -------------------------------------------------

variable "lakeformation_resource" {
  description = "(Optional) Provides Lake Formation Data Lake Location Resources."
  type = map(object({
    arn      = string           # (Required) Amazon Resource Name (ARN) of the resource, an S3 path.
    role_arn = optional(string) # (Optional) Role that has read/write access to the resource. If not provided, the Lake Formation service-linked role must exist and is used.
  }))

  default = null
}

# -------------------------------------------------
# Lakeformation Tag & Assignment Variables
# -------------------------------------------------

variable "lakeformation_tag" {
  description = "(Optional) Creates a map of LF-Tag with the specified name as key and a list of values. Each key must have at least one value. The maximum number of values permitted is 15."

  type = map(object({
    catalog_id = optional(string) # (Optional) ID of the Data Catalog to create the tag in. If omitted, this defaults to the AWS Account ID.)
    values     = list(string)     # (Required) List of possible values an attribute can take.
  }))

  default = null
}

variable "lakeformation_resource_tag" {
  description = "(Optional) Manages an attachment between one or more existing LF-tags and an existing Lake Formation resource."

  type = object({
    catalog_id = optional(string) # (Optional) Identifier for the Data Catalog. By default, the account ID.

    lf_tag = object({
      key        = string           # (Required) Key name for an existing LF-tag.
      value      = string           # (Required) Value from the possible values for the LF-tag.
      catalog_id = optional(string) # (Optional) Identifier for the Data Catalog. By default, it is the account ID of the caller.
    })

    database = optional(object({
      name       = string           # (Required) Name of the database resource. Unique to the Data Catalog.
      catalog_id = optional(string) # (Optional) Identifier for the Data Catalog. By default, it is the account ID of the caller.
    }))

    table = optional(object({
      database_name = string           # (Required) Name of the database for the table. Unique to a Data Catalog.
      name          = string           # (Required, at least one of name or wildcard) Name of the table.
      catalog_id    = optional(string) # (Optional) Identifier for the Data Catalog. By default, it is the account ID of the caller.
    }))

    table_with_columns = optional(object({
      column_names          = set(string)           # (Required, at least one of column_names or wildcard) Set of column names for the table.
      database_name         = string                # (Required) Name of the database for the table with columns resource. Unique to the Data Catalog.
      name                  = string                # (Required) Name of the table resource.
      wildcard              = string                # (Required, at least one of column_names or wildcard) Whether to use a column wildcard. If excluded_column_names is included, wildcard must be set to true to avoid Terraform reporting a difference.
      catalog_id            = optional(string)      # (Optional) Identifier for the Data Catalog. By default, it is the account ID of the caller.
      excluded_column_names = optional(set(string)) # (Optional) Set of column names for the table to exclude. If excluded_column_names is included, wildcard must be set to true to avoid Terraform reporting a difference.
    }))
  })

  default = null
}
