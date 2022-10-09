# workspaces.tf

locals {
  global = {
    tags = {
      Repository  = "pkdcloud/terraform-localstack"
      Workspace   = terraform.workspace
      Module      = "localstack"
      Environment = "sandbox"
    }
  }

  env = {
    pkd-sandbox-apse2 = {
      steps = ["ingest", "presentation"]
    }
  }

  workspace = local.env[terraform.workspace]
}
