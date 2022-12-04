# main.tf

# -------------------------------------------------
# Glue Database
# -------------------------------------------------

resource "aws_glue_catalog_database" "this" {
  count = var.enable_module ? 1 : 0

  catalog_id   = var.catalog_id
  description  = var.description
  location_uri = var.location_uri
  name         = var.name
  parameters   = var.parameters

  # dynamic "create_table_default_permission" {
  #   for_each = var.create_table_default_permission != null ? [true] : []

  #   content {
  #     permissions = try(var.create_table_default_permission.permissions, null)

  #     dynamic "principal" {
  #       for_each = try(var.create_table_default_permission.principal, null) != null ? [true] : []

  #       content {
  #         data_lake_principal_identifier = try(var.create_table_default_permission.principal.data_lake_principal_identifier, null)
  #       }
  #     }
  #   }
  # }

  # dynamic "target_database" {
  #   for_each = var.target_database != null ? [true] : []

  #   content {
  #     catalog_id    = var.target_database.catalog_id
  #     database_name = var.target_database.database_name
  #   }
  # }
}

# -------------------------------------------------
# Glue Tables
# -------------------------------------------------

resource "aws_glue_catalog_table" "this" {
  for_each = { for k, v in var.tables : k => v if var.enable_module }

  name          = each.key
  description   = each.value.description
  database_name = each.value.database_name
  catalog_id    = var.catalog_id
  # owner              = var.owner
  # parameters         = var.parameters
  # retention          = var.retention
  # table_type         = var.table_type
  # view_expanded_text = var.view_expanded_text
  # view_original_text = var.view_original_text

  # dynamic "partition_index" {
  #   for_each = var.partition_index != null ? [true] : []

  #   content {
  #     index_name = var.partition_index.index_name
  #     keys       = var.partition_index.keys
  #   }
  # }

  # dynamic "partition_keys" {
  #   for_each = var.partition_keys != null ? [true] : []

  #   content {
  #     name    = var.partition_keys.name
  #     comment = try(var.partition_keys.comment, null)
  #     type    = try(var.partition_keys.type, null)
  #   }
  # }

  # dynamic "target_table" {
  #   for_each = var.target_table != null ? [true] : []

  #   content {
  #     catalog_id    = var.target_table.catalog_id
  #     database_name = var.target_table.database_name
  #     name          = var.target_table.name
  #   }
  # }

  dynamic "storage_descriptor" {
    for_each = each.value.storage_descriptor != null ? [true] : []

    content {
      bucket_columns            = try(each.value.storage_descriptor.bucket_columns, null)
      compressed                = try(each.value.storage_descriptor.compressed, null)
      input_format              = try(each.value.storage_descriptor.input_format, null)
      location                  = try(each.value.storage_descriptor.location, null)
      number_of_buckets         = try(each.value.storage_descriptor.number_of_buckets, null)
      output_format             = try(each.value.storage_descriptor.output_format, null)
      parameters                = try(each.value.storage_descriptor.parameters, null)
      stored_as_sub_directories = try(each.value.storage_descriptor.stored_as_sub_directories, null)

      # dynamic "columns" {
      #   for_each = try(each.value.columns, null) != null ? each.value.columns : []

      #   content {
      #     name       = columns.value.name
      #     comment    = try(columns.value.comment, null)
      #     parameters = try(columns.value.parameters, null)
      #     type       = try(columns.value.type, null)
      #   }
      # }

      # dynamic "schema_reference" {
      #   for_each = try(each.value.schema_reference, null) != null ? [true] : []

      #   content {
      #     schema_version_number = each.value.schema_reference.schema_version_number
      #     schema_version_id     = try(each.value.schema_reference.schema_version_id, null)

      #     dynamic "schema_id" {
      #       for_each = try(each.value.schema_reference.schema_id, null) != null ? [true] : []

      #       content {
      #         registry_name = try(each.value.schema_reference.schema_id.registry_name, null)
      #         schema_arn    = try(each.value.schema_reference.schema_id.schema_arn, null)
      #         schema_name   = try(each.value.schema_reference.schema_id.schema_name, null)
      #       }
      #     }
      #   }
      # }

      # dynamic "ser_de_info" {
      #   for_each = try(each.value.ser_de_info, null) != null ? [true] : []

      #   content {
      #     name                  = try(each.value.ser_de_info.name, null)
      #     parameters            = try(each.value.ser_de_info.parameters, null)
      #     serialization_library = try(each.value.ser_de_info.serialization_library, null)
      #   }
      # }

      # dynamic "skewed_info" {
      #   for_each = try(each.value.skewed_info, null) != null ? [true] : []

      #   content {
      #     skewed_column_names               = try(each.value.skewed_info.skewed_column_names, null)
      #     skewed_column_value_location_maps = try(each.value.skewed_info.skewed_column_value_location_maps, null)
      #     skewed_column_values              = try(each.value.skewed_info.skewed_column_values, null)
      #   }
      # }

      # dynamic "sort_columns" {
      #   for_each = try(each.value.sort_columns, null) != null ? [true] : []

      #   content {
      #     column     = each.value.sort_columns.column
      #     sort_order = each.value.sort_columns.sort_order
      #   }
      # }
    }
  }

  depends_on = [
    aws_glue_catalog_database.this
  ]
}
