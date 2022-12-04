# workspaces.tf

locals {
  global = {
    tags = {
      Repository  = "pkdcloud/terraform-localstack"
      Workspace   = terraform.workspace
      Module      = "localstack"
      Environment = "sandbox"
    }

    steps = ["raw", "processed"]
  }

  env = {
    localstack = {
      aws_region  = "ap-southeast-2"
      aws_profile = "lks-shared-sandbox"

      glue = {
        database_name = "test"
      }

      s3 = {
        force_destroy = true
      }

      sns = {
        fifo_topic = false
      }

      sqs = {
        fifo_queue = false
      }
    }

    nonprod = {}

    prod = {}
  }

  workspace = local.env[terraform.workspace]
}
