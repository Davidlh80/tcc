output "role_name" {
  description = "Nome da role IAM."
  value       = aws_iam_role.app.name
}

output "role_arn" {
  description = "ARN da role IAM."
  value       = aws_iam_role.app.arn
}
