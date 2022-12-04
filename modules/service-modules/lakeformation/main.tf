# main.tf

# -------------------------------------------------
# Lakeformation Settings
# -------------------------------------------------

resource "aws_lakeformation_data_lake_settings" "this" {
  count = var.enable_module ? 1 : 0

  admins                  = var.admins
  catalog_id              = var.catalog_id
  trusted_resource_owners = var.trusted_resource_owners

  dynamic "create_database_default_permissions" {
    for_each = var.database_default_permissions
    content {
      permissions = create_database_default_permissions.value.permissions
      principal   = create_database_default_permissions.value.principal
    }
  }

  dynamic "create_table_default_permissions" {
    for_each = var.table_default_permissions
    content {
      permissions = create_table_default_permissions.value.permissions
      principal   = create_table_default_permissions.value.principal
    }
  }
}

# -------------------------------------------------
# Lakeformation Resources
# -------------------------------------------------

resource "aws_lakeformation_resource" "this" {
  for_each = { for k, v in var.locations : k => v if var.enable_module }
  arn      = each.value.arn
  role_arn = each.value.role_arn
}
