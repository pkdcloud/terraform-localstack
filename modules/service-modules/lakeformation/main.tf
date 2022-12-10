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
# Lakeformation Tags
# -------------------------------------------------

resource "aws_lakeformation_lf_tag" "this" {
  for_each = var.lakeformation_tag != null ? var.lakeformation_tag : {}

  catalog_id = each.value.catalog_id
  key        = each.key
  values     = each.value.values
}

# -------------------------------------------------
# Lakeformation Resources
# -------------------------------------------------

resource "aws_lakeformation_resource" "this" {
  for_each = var.lakeformation_resource != null ? var.lakeformation_resource : {}

  arn      = each.value.arn
  role_arn = each.value.role_arn
}

