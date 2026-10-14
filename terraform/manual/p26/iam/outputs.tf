output "policy_name" {
  description = "Nome da IAM Policy."
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "ARN da IAM Policy."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID da IAM Policy."
  value       = aws_iam_policy.this.policy_id
}

output "role_name" {
  description = "Nome da IAM Role."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "ARN da IAM Role."
  value       = aws_iam_role.this.arn
}
