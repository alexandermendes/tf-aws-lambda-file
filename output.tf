output "arn" {
  value       = aws_lambda_function.main.arn
  description = "The ARN of the Lambda function."
}

output "role_id" {
  value =     aws_iam_role.role.id
  description = "The ID of the role used for the Lambda function."
}
