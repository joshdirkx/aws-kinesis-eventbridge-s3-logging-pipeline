resource "random_string" "example_lambda_log_group" {
  length = 64
  special = false
  upper = false
}

resource "random_string" "kinesis_firehose_role" {
  length = 64
  special = false
  upper = false
}

resource "random_string" "destination_bucket_name" {
  length = 60
  special = false
  upper = false
}

resource "random_string" "kinesis_firehose_delivery_stream_name" {
  length = 64
  special = false
  upper = false
}

resource "random_string" "kinesis_firehose_role_policy" {
  length = 64
  special = false
  upper = false
}

resource "random_string" "kinesis_firehose_role_name" {
  length = 64
  special = false
  upper = false
}

resource "random_string" "kinesis_firehose_log_stream_name" {
  length = 64
  special = false
  upper = false
}
