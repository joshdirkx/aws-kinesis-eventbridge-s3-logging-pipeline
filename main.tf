terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.30.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "example_lambda" {
  source = "./lambda/example"
}

module "stream_lambda" {
  source = "./lambda/stream"
}

module "stream" {
  source = "./stream"

  event_bus_name = module.stream_lambda.event_bus_name
  example_lambda_function_name = module.example_lambda.lambda_function_name
  stream_lambda_function_name = module.stream_lambda.lambda_function_name
}
