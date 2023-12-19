terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.30.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

resource "null_resource" "publish" {
  provisioner "local-exec" {
    command = "./lambda/example/publish --aws_region ${var.aws_region} --ecr_repository_name ${aws_ecr_repository.this.name} --image_tag ${var.image_tag}"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_ecr_repository" "this" {
  name = random_string.ecr_repository_name.result
}

resource "aws_lambda_function" "this" {
  function_name    = random_string.lambda_function_name.result
  architectures    = ["arm64"]
  role             = aws_iam_role.this.arn
  package_type     = "Image"
  image_uri        = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.this.name}:${var.image_tag}"

  depends_on = [
    null_resource.publish
  ]
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 1
}

output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}
