# outputs.tf

output "id" {
  description = "The ARN of the SNS topic."
  value       = aws_sns_topic.this.id
}

output "arn" {
  description = "The ARN of the SNS topic, as a more obvious property (clone of id)."
  value       = aws_sns_topic.this.arn
}

output "owner" {
  description = "The AWS Account ID of the SNS topic owner."
  value       = aws_sns_topic.this.owner
}

output "tags_all" {
  description = " A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sns_topic.this.tags_all
}
