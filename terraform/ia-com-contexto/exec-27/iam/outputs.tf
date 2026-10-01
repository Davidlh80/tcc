output "policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID da IAM Policy criada."
  value       = aws_iam_policy.this.id
}

output "role_name" {
  description = "Nome da IAM Role criada e vinculada a policy."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "ARN da IAM Role criada e vinculada a policy."
  value       = aws_iam_role.this.arn
}

output "role_id" {
  description = "ID unico da IAM Role criada."
  value       = aws_iam_role.this.unique_id
}
