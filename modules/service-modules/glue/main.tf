# main.tf

resource "aws_glue_catalog_database" "this" {
  name       = var.database_name
  catalog_id = data.aws_caller_identity.current.account_id # Hack for localstack
}

data "aws_caller_identity" "current" {}

