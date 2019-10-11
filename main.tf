resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention
}

data "aws_iam_policy_document" "lambda_write_logs_policy_document" {
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

resource "aws_iam_role" "lambda" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "lambda_write_logs_policy" {
  name   = "${var.name}-write-logs-policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_write_logs_policy_document.json
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${var.dir}/${var.name}.${var.ext}"
  output_path = "${var.dir}/${var.name}.zip"
}

resource "aws_lambda_function" "main" {
  function_name    = var.name
  role             = aws_iam_role.lambda_role.arn
  handler          = "${var.name}.${var.handler}"
  runtime          = var.runtime
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  timeout          = var.timeout
  memory_size      = var.memory_size

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
