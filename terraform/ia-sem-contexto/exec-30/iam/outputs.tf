output "role_arn" {
  description = "ARN da IAM Role criada."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Nome da IAM Role criada."
  value       = aws_iam_role.this.name
}

output "role_unique_id" {
  description = "ID unico da IAM Role criada."
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
  description = "ID da IAM Policy criada."
  value       = aws_iam_policy.this.policy_id
}

output "role_policy_attachment_id" {
  description = "ID do anexo entre a IAM Policy gerenciada por este modulo e a IAM Role."
  value       = aws_iam_role_policy_attachment.this.id
}

output "assume_role_policy_json" {
  description = "Documento JSON da trust policy (assume role policy) aplicada a Role."
  value       = data.aws_iam_policy_document.assume_role.json
}
