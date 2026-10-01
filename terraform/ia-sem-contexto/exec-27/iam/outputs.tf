output "role_arn" {
  description = "ARN da IAM Role criada."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Nome da IAM Role criada."
  value       = aws_iam_role.this.name
}

output "role_id" {
  description = "ID da IAM Role criada."
  value       = aws_iam_role.this.id
}

output "role_unique_id" {
  description = "Identificador unico atribuido pela AWS a IAM Role."
  value       = aws_iam_role.this.unique_id
}

output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID da IAM Policy criada."
  value       = aws_iam_policy.this.id
}

output "policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "role_policy_attachment_id" {
  description = "ID do attachment entre a IAM Role e a IAM Policy."
  value       = aws_iam_role_policy_attachment.this.id
}
