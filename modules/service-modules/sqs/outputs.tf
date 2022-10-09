# outputs.tf

output "id" {
  description = "The URL for the created Amazon SQS queue."
  value       = aws_sqs_queue.this.id
}

output "arn" {
  description = "The ARN of the SQS queue."
  value       = aws_sqs_queue.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sqs_queue.this.tags_all
}

output "url" {
  description = "The URL for the created Amazon SQS queue."
  value       = aws_sqs_queue.this.url
}
