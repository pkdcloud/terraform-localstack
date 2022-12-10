# outputs.tf

output "full" {
  description = "(VERBOSE) Full export of the resource."
  value       = var.enable_module ? aws_kinesis_firehose_delivery_stream.this : null
}

output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the Stream"
  value       = var.enable_module ? aws_kinesis_firehose_delivery_stream.this[0].arn : null
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = var.enable_module ? aws_kinesis_firehose_delivery_stream.this[0].tags_all : null
}
