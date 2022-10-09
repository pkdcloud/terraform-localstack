# outputs.tf

# output "s3" {
#   value = module.s3
# }

output "sns_topic_arn" {
  value = module.sns.arn
}

output "sqs_url" {
  value = module.sqs.url
}

output "lambda_arn" {
  value = module.lambda.arn
}
