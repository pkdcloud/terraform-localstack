# workspaces.tf

locals {
  global = {
    tags = {
      Repository  = "pkdcloud/terraform-localstack"
      Workspace   = terraform.workspace
      Module      = "localstack"
      Environment = "sandbox"
    }

    steps = ["ingest", "presentation"]
  }

  env = {
    localstack = {
      s3 = {
        force_destroy = true
      }

      sns = {
        fifo_topic = true
      }

      sqs = {
        fifo_queue = true
      }
    }

    nonprod = {}

    prod = {}
  }

  workspace = local.env[terraform.workspace]
}
