# main.tf

#------------------------------------------------------
# Data Sources
#------------------------------------------------------

# data "aws_iam_policy_document" "assume_role_policy_lambda" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }
#   }
# }

# data "aws_iam_policy_document" "assume_role_policy_firehose" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["firehose.amazonaws.com"]
#     }
#   }
# }

# data "aws_iam_policy_document" "access_policy_lambda" {
#   statement {
#     sid = "SQSAccess"

#     actions = [
#       "sqs:DeleteMessage",
#       "sqs:GetQueueAttributes",
#       "sqs:ReceiveMessage"
#     ]

#     resources = [
#       module.sqs.arn,
#     ]
#   }

#   statement {
#     actions = [
#       "s3:*",
#     ]

#     resources = [
#       "${module.s3["ingest"].arn}",
#       "${module.s3["ingest"].arn}/*",
#     ]
#   }
# }

# data "aws_iam_policy_document" "access_policy_firehose" {
#   statement {
#     sid = "SQSAccess"

#     actions = [
#       "lambda:*"
#     ]

#     resources = [
#       module.sqs.arn,
#     ]
#   }
# }

# data "archive_file" "ingest_lambda" {
#   type        = "zip"
#   source_dir  = "${path.module}/src/ingest"
#   output_path = "${path.module}/builds/lambda-my-function.js.zip"
# }

data "aws_caller_identity" "current" {}

#------------------------------------------------------
# Module Implementations
#------------------------------------------------------

# module "lakeformation" {
#   source = "../../modules/service-modules/lakeformation"

#   enable_module = true
#   catalog_id           = data.aws_caller_identity.current.account_id
#   admins               = ["arn:aws:iam::524497320159:role/aws-reserved/sso.amazonaws.com/ap-southeast-2/AWSReservedSSO_AWSAdministratorAccess_7a447baaa8d5bebf"]
# }


module "s3" {
  for_each = toset(local.global.steps)

  source = "../../modules/service-modules/s3"

  bucket        = "${terraform.workspace}-${each.key}"
  force_destroy = local.workspace.s3.force_destroy
}

# module "iam_lambda" {
#   source = "../../modules/service-modules/iam"

#   name               = "${terraform.workspace}-ingest-processing-lambda"
#   assume_role_policy = data.aws_iam_policy_document.assume_role_policy_lambda.json
#   policy             = data.aws_iam_policy_document.access_policy_lambda.json
# }

# module "iam_firehose" {
#   source = "../../modules/service-modules/iam"

#   name               = "${terraform.workspace}-ingest-delivery-firehose"
#   assume_role_policy = data.aws_iam_policy_document.assume_role_policy_firehose.json
#   policy             = data.aws_iam_policy_document.access_policy_firehose.json
# }

# module "lambda" {
#   source = "../../modules/service-modules/lambda"

#   function_name = "${terraform.workspace}-ingest-processing"
#   role          = module.iam_lambda.arn
#   handler       = "index.lambda_handler"
#   runtime       = "python3.9"
#   filename      = data.archive_file.ingest_lambda.output_path

#   environment = {
#     "S3_BUCKET_NAME" = module.s3["ingest"].id
#   }

#   sqs_event_source_mapping = {
#     trigger_1 = {
#       event_source_arn = module.sqs.arn
#     }
#   }
# }

# module "sqs" {
#   source = "../../modules/service-modules/sqs"

#   name       = local.workspace.sqs.fifo_queue == true ? "${terraform.workspace}-events.fifo" : "${terraform.workspace}-events"
#   fifo_queue = local.workspace.sqs.fifo_queue
# }

# module "sns" {
#   source = "../../modules/service-modules/sns"

#   name       = local.workspace.sns.fifo_topic == true ? "${terraform.workspace}-events.fifo" : "${terraform.workspace}-events"
#   fifo_topic = local.workspace.sns.fifo_topic

#   topic_subscription = {
#     sqs_sub = {
#       endpoint             = module.sqs.arn
#       protocol             = "sqs"
#       raw_message_delivery = true
#     }
#   }
# }

module "glue" {
  source        = "../../modules/service-modules/glue"
  enable_module = true

  catalog_id   = data.aws_caller_identity.current.account_id
  name         = local.workspace.glue.database_name
  location_uri = "s3://${terraform.workspace}-processed/${local.workspace.glue.database_name}/"

  tables = {
    table_1 = {
      database_name = local.workspace.glue.database_name
      description   = "raw events"
      storage_descriptor = {
        location = "s3://${terraform.workspace}-processed/${local.workspace.glue.database_name}/table_1/"
      }
    }
    table_2 = {
      database_name = local.workspace.glue.database_name
      description   = "processed events"
      storage_descriptor = {
        location = "s3://${terraform.workspace}-processed/${local.workspace.glue.database_name}/table_2/"
      }
    }
  }
}

# module "firehose" {
#   for_each = toset(local.global.steps)

#   source = "../../modules/service-modules/kinesis-firehose"

#   name       = "${terraform.workspace}-${each.key}"
#   role_arn   = module.iam_firehose.arn
#   bucket_arn = module.s3[each.key].arn
# }

# module "rds" {
#   source = "../../modules/service-modules/rds"

# }
