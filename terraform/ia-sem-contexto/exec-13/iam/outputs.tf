output "iam_policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "iam_policy_id" {
  description = "ID unico da IAM Policy (policy_id)."
  value       = aws_iam_policy.this.policy_id
}

output "iam_policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "iam_policy_path" {
  description = "Path da IAM Policy criada."
  value       = aws_iam_policy.this.path
}

output "iam_policy_default_version_id" {
  description = "ID da versao padrao da policy."
  value       = aws_iam_policy.this.default_version_id
}

output "iam_policy_document_json" {
  description = "Documento JSON da policy (como enviado)."
  value       = aws_iam_policy.this.policy
}
