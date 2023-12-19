resource "random_string" "ecr_repository_name" {
  length = 64
  special = false
  upper = false
}

resource "random_string" "lambda_function_name" {
  length = 64
  special = false
  upper = false
}

resource "random_string" "event_bus_name" {
  length = 64
  special = false
  upper = false
}

resource "random_string" "event_archive_name" {
  length  = 48
  special = false
  upper   = false
}
