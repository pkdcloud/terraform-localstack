# main.tf

# -------------------------------------------------
# Firehose Resources
# -------------------------------------------------

resource "aws_kinesis_firehose_delivery_stream" "this" {
  count = var.enable_module ? 1 : 0

  name        = var.name
  destination = var.destination
  tags        = var.tags

  dynamic "kinesis_source_configuration" {
    for_each = var.kinesis_source_configuration != null ? [var.kinesis_source_configuration] : []

    content {
      kinesis_stream_arn = kinesis_source_configuration.value.kinesis_stream_arn
      role_arn           = kinesis_source_configuration.value.role_arn
    }
  }

  dynamic "server_side_encryption" {
    for_each = var.server_side_encryption != null ? [var.server_side_encryption] : []

    content {
      enabled  = server_side_encryption.value.enabled
      key_type = server_side_encryption.value.key_type
      key_arn  = server_side_encryption.value.key_arn
    }
  }

  dynamic "extended_s3_configuration" {
    for_each = var.extended_s3_configuration != null ? [var.extended_s3_configuration] : []

    content {
      role_arn            = extended_s3_configuration.value.role_arn
      bucket_arn          = extended_s3_configuration.value.bucket_arn
      prefix              = extended_s3_configuration.value.prefix
      buffer_size         = extended_s3_configuration.value.buffer_size
      buffer_interval     = extended_s3_configuration.value.buffer_interval
      compression_format  = extended_s3_configuration.value.compression_format
      error_output_prefix = extended_s3_configuration.value.error_output_prefix
      kms_key_arn         = extended_s3_configuration.value.kms_key_arn
      s3_backup_mode      = extended_s3_configuration.value.s3_backup_mode

      dynamic "dynamic_partitioning_configuration" {
        for_each = extended_s3_configuration.value.dynamic_partitioning_configuration != null ? [extended_s3_configuration.value.dynamic_partitioning_configuration] : []

        content {
          enabled        = dynamic_partitioning_configuration.value.enabled
          retry_duration = dynamic_partitioning_configuration.value.retry_duration
        }
      }

      dynamic "cloudwatch_logging_options" {
        for_each = var.cloudwatch_logging_options != null ? [var.cloudwatch_logging_options] : []

        content {
          enabled         = cloudwatch_logging_options.value.enabled
          log_group_name  = cloudwatch_logging_options.value.log_group_name
          log_stream_name = cloudwatch_logging_options.value.log_stream_name
        }
      }

      dynamic "processing_configuration" {
        for_each = var.processing_configuration != null ? [var.processing_configuration] : []
        content {
          enabled = processing_configuration.value.enabled

          dynamic "processors" {
            for_each = processing_configuration.value.processors != null ? processing_configuration.value.processors : []

            content {
              type = processors.value.type

              dynamic "parameters" {
                for_each = processors.value.parameters != null ? processors.value.parameters : []

                content {
                  parameter_name  = parameters.value.parameter_name
                  parameter_value = parameters.value.parameter_value
                }
              }
            }
          }
        }
      }

      dynamic "s3_backup_configuration" {
        for_each = var.s3_backup_configuration != null ? [var.s3_backup_configuration] : []

        content {
          role_arn            = s3_backup_configuration.value.role_arn
          bucket_arn          = s3_backup_configuration.value.bucket_arn
          prefix              = s3_backup_configuration.value.prefix
          buffer_size         = s3_backup_configuration.value.buffer_size
          buffer_interval     = s3_backup_configuration.value.buffer_interval
          compression_format  = s3_backup_configuration.value.compression_format
          error_output_prefix = s3_backup_configuration.value.error_output_prefix
          kms_key_arn         = s3_backup_configuration.value.kms_key_arn
        }
      }
    }
  }
}
