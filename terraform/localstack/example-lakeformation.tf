# main.tf

locals {
  lakeformation = { enable_module = true }
  steps         = ["raw", "processed"]
}

# ----------------------------------------------------------------------------------------
# Supporting Data Sources
# ----------------------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

# ----------------------------------------------------------------------------------------
# Supporting Resources & Modules
# ----------------------------------------------------------------------------------------

module "s3_lakeformation" {
  for_each = local.lakeformation.enable_module ? toset(local.steps) : []

  source = "../../modules/service-modules/s3"

  bucket        = "${terraform.workspace}-${each.key}"
  force_destroy = local.workspace.s3.force_destroy
}

# ----------------------------------------------------------------------------------------
# Example Module Implementation
# ----------------------------------------------------------------------------------------

module "lakeformation" {
  count  = local.lakeformation.enable_module ? 1 : 0
  source = "../../modules/service-modules/lakeformation"

  catalog_id = data.aws_caller_identity.current.account_id
  admins     = ["arn:aws:iam::524497320159:role/aws-reserved/sso.amazonaws.com/ap-southeast-2/AWSReservedSSO_AWSAdministratorAccess_7a447baaa8d5bebf"]

  # --------------------------
  # (IMPORTANT) Data Locations
  # --------------------------
  # Critical Info if you don't want to break Lakeformation permission scheme.
  # To add or update data, Lake Formation needs read/write access to the chosen Amazon S3 path.
  # Choose a role that you know has permission to do this, or choose the AWSServiceRoleForLakeFormationDataAccess service-linked role. 
  # When you register the first Amazon S3 path, the service-linked role and a new inline policy are created on your behalf. 
  # Lake Formation adds the first path to the inline policy and attaches it to the service-linked role. 
  # When you register subsequent paths, Lake Formation adds the path to the existing policy.

  lakeformation_resource = {
    events = {
      arn      = "${module.s3_lakeformation["processed"].arn}/events/"
      role_arn = "arn:aws:iam::524497320159:role/aws-reserved/sso.amazonaws.com/ap-southeast-2/AWSReservedSSO_AWSAdministratorAccess_7a447baaa8d5bebf"
    }
    # dms = {
    #   arn      = "${module.s3_lakeformation["processed"].arn}/dms/"
    #   role_arn = "arn:aws:iam::524497320159:role/aws-reserved/sso.amazonaws.com/ap-southeast-2/AWSReservedSSO_AWSAdministratorAccess_7a447baaa8d5bebf"
    # }
    # s3_replication = {
    #   arn      = "${module.s3_lakeformation["processed"].arn}/s3_replication/"
    #   role_arn = "arn:aws:iam::524497320159:role/aws-reserved/sso.amazonaws.com/ap-southeast-2/AWSReservedSSO_AWSAdministratorAccess_7a447baaa8d5bebf"
    # }
  }

  lakeformation_tag = {
    "projection" = {
      values = ["analytics", "profiles", "supppliers"]
    }
    "events" = {
      values = ["profiles", "infra"]
    }
    "dms" = {
      values = ["profiles", "infra"]
    }
    "s3_replication" = {
      values = ["profiles", "infra"]
    }
  }
}

output "debug1" {
  value = module.lakeformation
}
