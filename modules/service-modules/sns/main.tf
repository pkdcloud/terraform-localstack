# main.tf

resource "aws_sns_topic" "this" {
  name         = var.name
  name_prefix  = var.name_prefix
  display_name = var.display_name
}

resource "aws_sns_topic_subscription" "this" {
  for_each = var.topic_subscription

  endpoint  = each.value.endpoint
  protocol  = each.value.protocol
  topic_arn = aws_sns_topic.this.arn
}
