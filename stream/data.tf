data "aws_lambda_function" "example_lambda_function" {
  function_name = var.example_lambda_function_name
}

data "aws_lambda_function" "stream_lambda_function" {
  function_name = var.stream_lambda_function_name
}

data "aws_cloudwatch_log_group" "example_lambda_function_log_group" {
  name = "/aws/lambda/${var.example_lambda_function_name}"
}

data "aws_cloudwatch_event_bus" "event_bus" {
  name = var.event_bus_name
}

data "aws_caller_identity" "current" {}
