# main.tf

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  filename      = var.filename
  runtime       = var.runtime
  package_type  = var.package_type

  source_code_hash = filebase64sha256(var.filename) # PKD-TODO: Investigate why this hash changes each time, might be a localstack issue

  environment {
    variables = var.environment
  }
}

resource "aws_lambda_event_source_mapping" "sqs" {
  for_each = var.sqs_event_source_mapping

  event_source_arn  = each.value.event_source_arn
  function_name     = aws_lambda_function.this.arn
  starting_position = "LATEST" # PKD-TODO: Parameterise starting_position
}
