# main.tf

# ----------------------------------------------------------------------------------------
# Supporting Data Sources
# ----------------------------------------------------------------------------------------

data "aws_iam_policy_document" "assume_role_policy_firehose" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "access_policy_firehose" {
  statement {
    sid = "LambdaAccess"

    actions = [
      "lambda:*"
    ]

    resources = [
      "*"
    ]
  }
}

# ----------------------------------------------------------------------------------------
# Supporting Resources & Modules
# ----------------------------------------------------------------------------------------

module "iam_firehose" {
  source = "../../modules/service-modules/iam"

  name               = "${terraform.workspace}-raw-deliverystream-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_firehose.json
  policy             = data.aws_iam_policy_document.access_policy_firehose.json
}

module "kms_firehose" {
  source = "../../modules/service-modules/kms"
  name   = "alias/raw-firehose"
}

module "kms_s3" {
  source = "../../modules/service-modules/kms"
  name   = "alias/raw-s3"
}

module "s3" {
  source        = "../../modules/service-modules/s3"
  bucket        = "lks-test-bucket"
  force_destroy = true
}

# ----------------------------------------------------------------------------------------
# Sample Module
# ----------------------------------------------------------------------------------------

module "firehose" {
  source = "../../modules/service-modules/kinesis-firehose"

  name          = "test-stream-s3-extended"
  destination   = "extended_s3"
  enable_module = false

  server_side_encryption = {
    enabled  = true
    key_type = "CUSTOMER_MANAGED_CMK"
    key_arn  = module.kms_s3.alias_arn
  }

  extended_s3_configuration = {
    role_arn            = module.iam_firehose.arn
    bucket_arn          = module.s3.arn
    buffer_interval     = 60
    buffer_size         = 5
    prefix              = "data/events"
    error_output_prefix = "errors/events"
    kms_key_arn         = module.kms_firehose.alias_arn

    dynamic_partitioning_configuration = {
      enabled        = true
      retry_duration = 300
    }
  }

  cloudwatch_logging_options = {
    enabled         = true
    log_group_name  = "/aws/kinesis-firehose-test"
    log_stream_name = "raw-delivery-stream-test"
  }

  processing_configuration = {
    enabled = true
    processors = [
      {
        type = "AppendDelimiterToRecord"
      },
      {
        type = "MetadataExtraction"
        parameters = [
          {
            parameter_name  = "JsonParsingEngine"
            parameter_value = "JQ-1.6"
          },
          {
            parameter_name  = "MetadataExtractionQuery"
            parameter_value = "{id:.id}"
          }
        ]
      }
    ]
  }
}
