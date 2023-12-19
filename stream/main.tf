resource "aws_cloudwatch_log_subscription_filter" "this" {
  name            = random_string.example_lambda_log_group.result
  log_group_name  = "/aws/lambda/${var.example_lambda_function_name}"
  filter_pattern  = ""
  destination_arn = data.aws_lambda_function.stream_lambda_function.arn
}

resource "aws_cloudwatch_event_rule" "this" {
  event_bus_name = data.aws_cloudwatch_event_bus.event_bus.name

  event_pattern = jsonencode({
    "source" : [
      {
        "prefix" : ""
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/kinesisfirehose/${random_string.kinesis_firehose_delivery_stream_name.result}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "this" {
  log_group_name = aws_cloudwatch_log_group.this.name
  name           = random_string.kinesis_firehose_log_stream_name.result
}


resource aws_s3_bucket "destination_bucket" {
  bucket = random_string.destination_bucket_name.result
}

resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = random_string.kinesis_firehose_delivery_stream_name.result
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn = aws_iam_role.this.arn
    bucket_arn = aws_s3_bucket.destination_bucket.arn

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.this.name
      log_stream_name = aws_cloudwatch_log_stream.this.name
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = random_string.kinesis_firehose_role.result
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_cloudwatch_event_target" "this" {
  event_bus_name = data.aws_cloudwatch_event_bus.event_bus.name
  rule           = aws_cloudwatch_event_rule.this.name
  arn            = aws_kinesis_firehose_delivery_stream.this.arn
  role_arn       = aws_iam_role.this.arn
}

#resource "aws_iam_role_policy" "this" {
#  name   = random_string.kinesis_firehose_role_policy.result
#  role   = aws_iam_role.this.id
#
#  policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [
#      {
#        Action = [
#          "firehose:PutRecord",
#          "firehose:PutRecordBatch",
#          "kinesis:DescribeStream",
#          "kinesis:GetShardIterator",
#          "kinesis:GetRecords",
#          "kinesis:ListShards"
#        ],
#        Effect   = "Allow",
#        Resource = aws_kinesis_firehose_delivery_stream.this.arn
#      }
#      },
#      {
#        "Effect": "Allow",
#        "Action": [
#            "s3:AbortMultipartUpload",
#            "s3:GetBucketLocation",
#            "s3:GetObject",
#            "s3:ListBucket",
#            "s3:ListBucketMultipartUploads",
#            "s3:PutObject"
#        ],
#        "Resource": [
#          "${aws_s3_bucket.destination_bucket.arn}/*",
#          aws_s3_bucket.destination_bucket.arn
#        ]
#      }
#    ]
#  })
#}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  function_name = var.stream_lambda_function_name
  principal     = "logs.${var.aws_region}.amazonaws.com"
  source_arn    = "${data.aws_cloudwatch_log_group.example_lambda_function_log_group.arn}:*"
}

output "kinesis_firehose_role_name" {
  value = aws_iam_role.this.name
}
