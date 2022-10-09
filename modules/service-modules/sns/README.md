# AWS SNS Terraform Module

## Resources still to implement

- aws_sns_platform_application
- aws_sns_sms_preferences
- aws_sns_topic_policy
- aws_sns_topic_subscription


## aws_sns_topic

The following is a list of arguments yet to implement

policy - (Optional) The fully-formed AWS policy as JSON. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide.

delivery_policy - (Optional) The SNS delivery policy. More on AWS documentation
application_success_feedback_role_arn - (Optional) The IAM role permitted to receive success feedback for this topic

application_success_feedback_sample_rate - (Optional) Percentage of success to sample

application_failure_feedback_role_arn - (Optional) IAM role for failure feedback

http_success_feedback_role_arn - (Optional) The IAM role permitted to receive success feedback for this topic

http_success_feedback_sample_rate - (Optional) Percentage of success to sample

http_failure_feedback_role_arn - (Optional) IAM role for failure feedback

kms_master_key_id - (Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. For more information, see Key Terms

fifo_topic - (Optional) Boolean indicating whether or not to create a FIFO (first-in-first-out) topic (default is false).

content_based_deduplication - (Optional) Enables content-based deduplication for FIFO topics. For more information, see the related documentation

lambda_success_feedback_role_arn - (Optional) The IAM role permitted to receive success feedback for this topic

lambda_success_feedback_sample_rate - (Optional) Percentage of success to sample

lambda_failure_feedback_role_arn - (Optional) IAM role for failure feedback

sqs_success_feedback_role_arn - (Optional) The IAM role permitted to receive success feedback for this topic

sqs_success_feedback_sample_rate - (Optional) Percentage of success to sample

sqs_failure_feedback_role_arn - (Optional) IAM role for failure feedback

firehose_success_feedback_role_arn - (Optional) The IAM role permitted to receive success feedback for this topic

firehose_success_feedback_sample_rate - (Optional) Percentage of success to sample


firehose_failure_feedback_role_arn - (Optional) IAM role for failure feedback

tags - (Optional) Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level.
