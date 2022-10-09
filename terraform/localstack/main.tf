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
  output_path = "${path.module}/files/lambda-my-function.js.zip"
}

#------------------------------------------------------
# Module Implementations
#------------------------------------------------------

module "s3" {
  for_each = toset(local.workspace.steps)

  source = "../../modules/service-modules/s3"

  bucket = "${terraform.workspace}-${each.key}"
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

  name = "${terraform.workspace}-events"
}

module "sns" {
  source = "../../modules/service-modules/sns"

  name = "${terraform.workspace}-events"

  topic_subscription = {
    subscription_1 = {
      endpoint = module.sqs.arn
      protocol = "sqs"
    }
  }
}

# resource "aws_iam_role" "iam_for_lambda" {
#   name = "iam_for_lambda"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }