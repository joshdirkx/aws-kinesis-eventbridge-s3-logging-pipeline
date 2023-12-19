variable "aws_region" {
  type = string
  default = "us-west-2"
}

variable "example_lambda_function_name" {
  type = string
}

variable "stream_lambda_function_name" {
  type = string
}

variable "event_bus_name" {
  type = string
}
