
# terraform.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17"
    }
  }

  #   backend "s3" {
  #   }
}

provider "aws" {
  region  = local.workspace["aws_region"]
  profile = local.workspace["aws_profile"]

  default_tags {
    tags = local.global["tags"]
  }
}
