output "policy_arn" {
  description = "ARN da IAM Policy."
  value       = aws_iam_policy.this.arn
}

output "role_arn" {
  description = "ARN da IAM Role."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Nome da IAM Role."
  value       = aws_iam_role.this.name
}
