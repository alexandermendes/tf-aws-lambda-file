output "arn" {
  value       = aws_lambda_function.main.arn
  description = "The ARN of the Lambda function."
}

output "qualified_arn" {
  value       = aws_lambda_function.main.qualified_arn
  description = "The ARN identifying the Lambda function version (if versioning is enabled via publish = true)."
}

output "invoke_arn" {
  value       = aws_lambda_function.main.invoke_arn
  description = "The ARN to be used for invoking Lambda Function from API Gateway."
}

output "version" {
  value       = aws_lambda_function.main.version
  description = "Latest published version of your Lambda Function."
}

output "last_modified" {
  value       = aws_lambda_function.main.last_modified
  description = "The date this resource was last modified."
}

output "role_id" {
  value       = aws_iam_role.role.id
  description = "The ID of the role used for the Lambda function."
}

output "name" {
  value       = var.name
  description = "The name of the Lambda function."
}
