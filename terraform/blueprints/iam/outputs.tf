output "policy_name" {
  description = "policy_name do recurso criado."
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "policy_arn do recurso criado."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "policy_id do recurso criado."
  value       = aws_iam_policy.this.policy_id
}

output "role_name" {
  description = "role_name do recurso criado."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "role_arn do recurso criado."
  value       = aws_iam_role.this.arn
}
