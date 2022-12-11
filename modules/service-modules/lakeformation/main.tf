# main.tf

# -------------------------------------------------
# Lakeformation Settings
# -------------------------------------------------

resource "aws_lakeformation_data_lake_settings" "this" {
  admins                  = var.admins
  catalog_id              = var.catalog_id
  trusted_resource_owners = var.trusted_resource_owners

  dynamic "create_database_default_permissions" {
    for_each = var.create_database_default_permissions != null ? [var.create_database_default_permissions] : []

    content {
      permissions = create_database_default_permissions.value.permissions
      principal   = create_database_default_permissions.value.principal
    }
  }

  dynamic "create_table_default_permissions" {
    for_each = var.create_table_default_permissions != null ? [var.create_table_default_permissions] : []
    content {
      permissions = create_table_default_permissions.value.permissions
      principal   = create_table_default_permissions.value.principal
    }
  }
}

# -------------------------------------------------
# Lakeformation Tags & Tag Attachments
# -------------------------------------------------

resource "aws_lakeformation_lf_tag" "this" {
  for_each = var.lakeformation_tag != null ? var.lakeformation_tag : {}

  catalog_id = each.value.catalog_id
  key        = each.key
  values     = each.value.values
}

resource "aws_lakeformation_resource_lf_tags" "this" {

  catalog_id = "xxxxxxx" # (Optional) Identifier for the Data Catalog. By default, the account ID. The Data Catalog is the persistent metadata store. It contains database definitions, table definitions, and other control information to manage your Lake Formation environment.

  dynamic "database" {
    for_each = extended_s3_configuration.value.dynamic_partitioning_configuration != null ? [extended_s3_configuration.value.dynamic_partitioning_configuration] : []

    content {
      name       = string
      catalog_id = optional(string)
    }
  }
  database {
    name       = string
    catalog_id = optional(string)
  }

  # (Optional) Configuration block for a table resource.
  table {
    database_name = string
    name          = string
    catalog_id    = optional(string)
  }

  # (Optional) Configuration block for a table with columns resource. 
  table_with_columns {
    column_names          = set(string)
    database_name         = string
    name                  = string
    wildcard              = string
    catalog_id            = optional(string)
    excluded_column_names = optional(set(string))
  }

  # (Required) Set of LF-tags to attach to the resource.
  lf_tag {
    key        = string
    value      = string
    catalog_id = optional(string)
  }
}



# dynamic "extended_s3_configuration" {
#   for_each = var.extended_s3_configuration != null ? [var.extended_s3_configuration] : []

#   content {
#     role_arn            = extended_s3_configuration.value.role_arn
#     bucket_arn          = extended_s3_configuration.value.bucket_arn
#     prefix              = extended_s3_configuration.value.prefix
#     buffer_size         = extended_s3_configuration.value.buffer_size
#     buffer_interval     = extended_s3_configuration.value.buffer_interval
#     compression_format  = extended_s3_configuration.value.compression_format
#     error_output_prefix = extended_s3_configuration.value.error_output_prefix
#     kms_key_arn         = extended_s3_configuration.value.kms_key_arn
#     s3_backup_mode      = extended_s3_configuration.value.s3_backup_mode

#     dynamic "dynamic_partitioning_configuration" {
#       for_each = extended_s3_configuration.value.dynamic_partitioning_configuration != null ? [extended_s3_configuration.value.dynamic_partitioning_configuration] : []

#       content {
#         enabled        = dynamic_partitioning_configuration.value.enabled
#         retry_duration = dynamic_partitioning_configuration.value.retry_duration
#       }
#     }

#     dynamic "cloudwatch_logging_options" {
#       for_each = var.cloudwatch_logging_options != null ? [var.cloudwatch_logging_options] : []

#       content {
#         enabled         = cloudwatch_logging_options.value.enabled
#         log_group_name  = cloudwatch_logging_options.value.log_group_name
#         log_stream_name = cloudwatch_logging_options.value.log_stream_name
#       }
#     }

#     dynamic "processing_configuration" {
#       for_each = var.processing_configuration != null ? [var.processing_configuration] : []
#       content {
#         enabled = processing_configuration.value.enabled

#         dynamic "processors" {
#           for_each = processing_configuration.value.processors != null ? processing_configuration.value.processors : []

#           content {
#             type = processors.value.type

#             dynamic "parameters" {
#               for_each = processors.value.parameters != null ? processors.value.parameters : []

#               content {
#                 parameter_name  = parameters.value.parameter_name
#                 parameter_value = parameters.value.parameter_value
#               }
#             }
#           }
#         }
#       }
#     }

#     dynamic "s3_backup_configuration" {
#       for_each = var.s3_backup_configuration != null ? [var.s3_backup_configuration] : []

#       content {
#         role_arn            = s3_backup_configuration.value.role_arn
#         bucket_arn          = s3_backup_configuration.value.bucket_arn
#         prefix              = s3_backup_configuration.value.prefix
#         buffer_size         = s3_backup_configuration.value.buffer_size
#         buffer_interval     = s3_backup_configuration.value.buffer_interval
#         compression_format  = s3_backup_configuration.value.compression_format
#         error_output_prefix = s3_backup_configuration.value.error_output_prefix
#         kms_key_arn         = s3_backup_configuration.value.kms_key_arn
#       }
#     }
#   }
# }



# -------------------------------------------------
# Lakeformation Permissions
# -------------------------------------------------

resource "aws_lakeformation_resource" "this" {
  for_each = var.lakeformation_resource != null ? var.lakeformation_resource : {}

  arn      = each.value.arn
  role_arn = each.value.role_arn
}



