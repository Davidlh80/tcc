output "role_arn" {
  description = "ARN da IAM Role criada."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Nome da IAM Role criada."
  value       = aws_iam_role.this.name
}

output "role_id" {
  description = "ID unico da IAM Role criada."
  value       = aws_iam_role.this.id
}

output "policy_arn" {
  description = "ARN da IAM Policy criada e anexada a role."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "assume_role_policy_json" {
  description = "Documento JSON da trust policy (assume role) da role."
  value       = data.aws_iam_policy_document.assume_role.json
}
