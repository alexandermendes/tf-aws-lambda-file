locals {
  name = replace(join("-", [var.namespace, var.function_name]), "/^-/", "")
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${local.name}"
  retention_in_days = var.log_retention
}

data "aws_iam_policy_document" "write_logs_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.logs.arn
    ]
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "write_logs_policy" {
  name   = "${local.name}-write-logs"
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.write_logs_policy_document.json
}

resource "aws_iam_role" "role" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${var.dir}/${var.function_name}.${var.ext}"
  output_path = "${var.dir}/${local.name}.zip"
}

resource "aws_lambda_function" "main" {
  function_name    = local.name
  role             = aws_iam_role.role.arn
  handler          = "${local.name}.${var.handler}"
  runtime          = var.runtime
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  timeout          = var.timeout
  memory_size      = var.memory_size
  layers           = var.layers

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]

    content {
      variables = environment.value.variables
    }
  }
}
