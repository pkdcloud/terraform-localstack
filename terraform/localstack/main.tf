# main.tf

#------------------------------------------------------
# Data Sources
#------------------------------------------------------

data "aws_iam_policy_document" "assume_role_policy_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy_kinesis_firehose" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_access_policy" {
  statement {
    sid = "SQSAccess"

    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage"
    ]

    resources = [
      module.sqs.arn,
    ]
  }

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "${module.s3["ingest"].arn}",
      "${module.s3["ingest"].arn}/*",
    ]
  }
}

data "archive_file" "ingest_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/src/ingest"
  output_path = "${path.module}/builds/lambda-my-function.js.zip"
}

#------------------------------------------------------
# Module Implementations
#------------------------------------------------------

module "s3" {
  for_each = toset(local.global.steps)

  source = "../../modules/service-modules/s3"

  bucket        = "${terraform.workspace}-${each.key}"
  force_destroy = local.workspace.s3.force_destroy
}

module "iam" {
  source = "../../modules/service-modules/iam"

  name               = "${terraform.workspace}-ingest-processing-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_lambda.json
  policy             = data.aws_iam_policy_document.lambda_access_policy.json
}

module "lambda" {
  source = "../../modules/service-modules/lambda"

  function_name = "${terraform.workspace}-ingest-processing"
  role          = module.iam.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  filename      = data.archive_file.ingest_lambda.output_path

  environment = {
    "S3_BUCKET_NAME" = module.s3["ingest"].id
  }

  sqs_event_source_mapping = {
    trigger_1 = {
      event_source_arn = module.sqs.arn
    }
  }
}

module "sqs" {
  source = "../../modules/service-modules/sqs"

  name       = local.workspace.sqs.fifo_queue == true ? "${terraform.workspace}-events.fifo" : "${terraform.workspace}-events"
  fifo_queue = local.workspace.sqs.fifo_queue
}

module "sns" {
  source = "../../modules/service-modules/sns"

  name       = local.workspace.sns.fifo_topic == true ? "${terraform.workspace}-events.fifo" : "${terraform.workspace}-events"
  fifo_topic = local.workspace.sns.fifo_topic

  topic_subscription = {
    sqs_sub = {
      endpoint             = module.sqs.arn
      protocol             = "sqs"
      raw_message_delivery = true
    }
  }
}

# module "glue" {
#   source = "../../modules/service-modules/glue"

#   database_name = terraform.workspace
# }

# module "firehose" {
#   for_each = toset(local.global.steps)

#   source = "../../modules/service-modules/kinesis-firehose"

#   name       = "${terraform.workspace}-${each.key}"
#   role_arn   = data.aws_iam_policy_document.assume_role_policy_kinesis_firehose.json
#   bucket_arn = module.s3[each.key].arn
# }
