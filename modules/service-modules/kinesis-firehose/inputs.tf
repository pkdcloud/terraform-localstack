# inputs.tf

# TODO: NOT YET IMPLEMENTED Nested argument for the serializer, deserializer, and schema for converting data from the JSON format to the Parquet or ORC format before writing it to Amazon S3. 
# - data_format_conversion_configuration = optional(object({}))
# Many more alts other than extended s3

variable "enable_module" {
  description = "Enables the Module. Disabling tears down all module resources."
  type        = bool
  default     = true
}

variable "name" {
  description = "(Required) A name to identify the stream. This is unique to the AWS account and region the Stream is created in."
  type        = string
}

variable "destination" {
  description = " (Required) This is the destination to where the data is delivered. The only options are extended_s3, redshift, elasticsearch, splunk, and http_endpoint."
  type        = string
}

variable "tags" {
  description = "(Optional) A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(any)
  default     = {}
}

variable "kinesis_source_configuration" {
  description = "(Optional) Allows the ability to specify the kinesis stream that is used as the source of the firehose delivery stream."

  type = object({
    kinesis_stream_arn = string # The kinesis stream used as the source of the firehose delivery stream.
    role_arn           = string # The ARN of the role that provides access to the source Kinesis stream.
  })

  default = null
}

variable "server_side_encryption" {
  description = "(Optional) Encrypt at rest options. Server-side encryption should not be enabled when a kinesis stream is configured as the source of the firehose delivery stream."

  type = object({
    enabled  = optional(bool)   # Whether to enable encryption at rest. Default is false.
    key_type = optional(string) # Type of encryption key. Default is AWS_OWNED_CMK. Valid values are AWS_OWNED_CMK and CUSTOMER_MANAGED_CMK
    key_arn  = optional(string) # (Amazon Resource Name (ARN) of the encryption key. Required when key_type is CUSTOMER_MANAGED_CMK.
  })

  default = null
}

variable "extended_s3_configuration" {
  description = "(Optional), only Required when destination is extended_s3."

  type = object({
    role_arn            = string           # The ARN of the AWS credentials.
    bucket_arn          = string           # The ARN of the S3 bucket.
    prefix              = optional(string) # The "YYYY/MM/DD/HH" time format prefix is automatically used for delivered S3 files. You can specify an extra prefix to be added in front of the time format prefix. Note that if the prefix ends with a slash, it appears as a folder in the S3 bucket.
    buffer_size         = optional(number) # Buffer incoming data to the specified size, in MBs, before delivering it to the destination. The default value is 5. We recommend setting SizeInMBs to a value greater than the amount of data you typically ingest into the delivery stream in 10 seconds. For example, if you typically ingest data at 1 MB/sec set SizeInMBs to be 10 MB or higher.
    buffer_interval     = optional(number) # Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. The default value is 300.
    compression_format  = optional(string) # The compression format. If no value is specified, the default is UNCOMPRESSED. Other supported values are GZIP, ZIP, Snappy, & HADOOP_SNAPPY.
    error_output_prefix = optional(string) # Prefix added to failed records before writing them to S3. Not currently supported for redshift destination. This prefix appears immediately following the bucket name. For information about how to specify this prefix, see Custom Prefixes for Amazon S3 Objects.
    kms_key_arn         = optional(string) # Specifies the KMS key ARN the stream will use to encrypt data. If not set, no encryption will be used.
    s3_backup_mode      = optional(bool)   # The Amazon S3 backup mode. Valid values are Disabled and Enabled. Default value is Disabled.

    dynamic_partitioning_configuration = optional(object({
      enabled        = optional(bool)   # Enables or disables dynamic partitioning. Defaults to false.
      retry_duration = optional(number) # Total amount of seconds Firehose spends on retries. Valid values between 0 and 7200. Default is 300.
    }))
  })

  default = null
}

variable "cloudwatch_logging_options" {
  description = "(Optional) The configuration for dynamic partitioning."

  type = object({
    enabled         = optional(bool)   # Enables or disables the logging. Defaults to false.
    log_group_name  = optional(string) # The CloudWatch group name for logging. This value is required if enabled is true.
    log_stream_name = optional(string) # CloudWatch log stream name for logging. This value is required if enabled is true.

  })

  default = null
}

variable "processing_configuration" {
  description = "(Optional) The data processing configuration."

  type = object({
    enabled = optional(bool) #(Optional) Enables or disables data processing.

    processors = optional(set(object({
      type = string # (Required) The type of processor. Valid Values: RecordDeAggregation, Lambda, MetadataExtraction, AppendDelimiterToRecord.

      parameters = optional(set(object({
        parameter_name  = string # Parameter name. Valid Values: LambdaArn, NumberOfRetries, MetadataExtractionQuery, JsonParsingEngine, RoleArn, BufferSizeInMBs, BufferIntervalInSeconds, SubRecordType, Delimiter. Validation is done against AWS SDK constants; so that values not explicitly listed may also work.
        parameter_value = string # Parameter value. Must be between 1 and 512 length (inclusive). When providing a Lambda ARN, you should specify the resource version as well.
      })))
    })))
  })

  default = null
}

variable "s3_backup_configuration" {
  description = "(Optional) The configuration for backup in Amazon S3. Required if s3_backup_mode is Enabled."

  type = object({
    role_arn            = string           # The ARN of the AWS credentials.
    bucket_arn          = string           # The ARN of the S3 bucket.
    prefix              = optional(string) # The "YYYY/MM/DD/HH" time format prefix is automatically used for delivered S3 files. You can specify an extra prefix to be added in front of the time format prefix. Note that if the prefix ends with a slash, it appears as a folder in the S3 bucket.
    buffer_size         = optional(number) # Buffer incoming data to the specified size, in MBs, before delivering it to the destination. The default value is 5. We recommend setting SizeInMBs to a value greater than the amount of data you typically ingest into the delivery stream in 10 seconds. For example, if you typically ingest data at 1 MB/sec set SizeInMBs to be 10 MB or higher.
    buffer_interval     = optional(number) # Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. The default value is 300.
    compression_format  = optional(string) # The compression format. If no value is specified, the default is UNCOMPRESSED. Other supported values are GZIP, ZIP, Snappy, & HADOOP_SNAPPY.
    error_output_prefix = optional(string) # Prefix added to failed records before writing them to S3. Not currently supported for redshift destination. This prefix appears immediately following the bucket name. For information about how to specify this prefix, see Custom Prefixes for Amazon S3 Objects.
    kms_key_arn         = optional(string) # Specifies the KMS key ARN the stream will use to encrypt data. If not set, no encryption will be used.
  })

  default = null
}
