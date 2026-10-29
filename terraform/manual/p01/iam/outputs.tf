output "policy_name" {
  description = "Nome da policy IAM criada"
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "ARN da policy IAM criada"
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID da policy IAM criada"
  value       = aws_iam_policy.this.policy_id
}

output "role_name" {
  description = "Nome da role IAM criada"
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "ARN da role IAM criada"
  value       = aws_iam_role.this.arn
}
