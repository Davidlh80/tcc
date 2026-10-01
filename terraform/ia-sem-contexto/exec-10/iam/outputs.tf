output "role_arn" {
  description = "ARN da IAM Role criada."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Nome da IAM Role criada."
  value       = aws_iam_role.this.name
}

output "role_unique_id" {
  description = "Identificador unico gerado pela AWS para a IAM Role."
  value       = aws_iam_role.this.unique_id
}

output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "policy_id" {
  description = "Identificador da IAM Policy criada."
  value       = aws_iam_policy.this.policy_id
}

output "role_policy_attachment_id" {
  description = "Identificador do attachment entre a IAM Policy e a IAM Role."
  value       = aws_iam_role_policy_attachment.this.id
}
